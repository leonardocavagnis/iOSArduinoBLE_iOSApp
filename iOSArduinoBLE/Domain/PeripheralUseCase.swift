//
//  PeripheralUseCase.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import Foundation
import CoreBluetooth

protocol PeripheralUseCaseProtocol {
    
    var peripheral: Peripheral? { get set }
    
    var onWriteLedState: ((Bool) -> Void)? { get set }
    var onReadTemperature: ((Int) -> Void)? { get set }
    var onPeripheralReady: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }


    func writeLedState(isOn: Bool)
    func readTemperature()
    func notifyTemperature(_ isOn: Bool)
}

class PeripheralUseCase: NSObject, PeripheralUseCaseProtocol {
    
    var peripheral: Peripheral? {
        didSet {
            self.peripheral?.cbPeripheral?.delegate = self
            discoverServices()
        }
    }
    
    var cbPeripheral: CBPeripheral? {
        peripheral?.cbPeripheral
    }
    
    var onWriteLedState: ((Bool) -> Void)?
    var onReadTemperature: ((Int) -> Void)?
    var onPeripheralReady: (() -> Void)?
    var onError: ((Error) -> Void)?
    
   
    var discoveredServices = [CBUUID : CBService]()
    var discoveredCharacteristics = [CBUUID : CBCharacteristic]()
    
    func discoverServices() {
        cbPeripheral?.discoverServices([UUIDs.ledService, UUIDs.sensorService])
    }
    
    func writeLedState(isOn: Bool) {
        guard let ledCharacteristic = discoveredCharacteristics[UUIDs.ledStatusCharacteristic] else {
            return
        }
        cbPeripheral?.writeValue(Data(isOn ? [0x01] : [0x00]), for: ledCharacteristic, type: .withResponse)
    }
    
    func readTemperature() {
        guard let tempCharacteristic = discoveredCharacteristics[UUIDs.temperatureCharacteristic] else {
            return
        }
        cbPeripheral?.readValue(for: tempCharacteristic)
    }
    
    func notifyTemperature(_ isOn: Bool) {
        guard let tempCharacteristic = discoveredCharacteristics[UUIDs.temperatureCharacteristic] else {
            return
        }
        cbPeripheral?.setNotifyValue(isOn, for: tempCharacteristic)
    }
    
    
    fileprivate func requiredCharacteristicUUIDs(for service: CBService) -> [CBUUID] {
        switch service.uuid {
        case UUIDs.ledService where discoveredCharacteristics[UUIDs.ledStatusCharacteristic] == nil:
            return [UUIDs.ledStatusCharacteristic]
        case UUIDs.sensorService where discoveredCharacteristics[UUIDs.temperatureCharacteristic] == nil:
            return [UUIDs.temperatureCharacteristic]
        default:
            return []
        }
    }
}

extension PeripheralUseCase: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services, error == nil else {
            return
        }
        for service in services {
            discoveredServices[service.uuid] = service
            let uuids = requiredCharacteristicUUIDs(for: service)
            guard !uuids.isEmpty else {
                return
            }
            peripheral.discoverCharacteristics(uuids, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        for characteristic in characteristics {
            discoveredCharacteristics[characteristic.uuid] = characteristic
        }

        if discoveredCharacteristics[UUIDs.temperatureCharacteristic] != nil &&
            discoveredCharacteristics[UUIDs.ledStatusCharacteristic] != nil {
            onPeripheralReady?()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error {
            onError?(error)
            return
        }
        switch characteristic.uuid {
        case UUIDs.ledStatusCharacteristic:
            let value: UInt8 = {
                guard let value = characteristic.value?.first else {
                    return 0
                }
                return value
            }()
            onWriteLedState?(value != 0 ? true : false)
        default:
            fatalError()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case UUIDs.temperatureCharacteristic:
            let value: UInt8 = {
                guard let value = characteristic.value?.first else {
                    return 0
                }
                return value
            }()
            onReadTemperature?(Int(value))
        default:
            fatalError()
        }
    }
}
