//
//  CentralUseCase.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import Foundation
import CoreBluetooth

protocol ConnectUseCaseProtocol {
    var onConnection: ((Peripheral) -> Void)? { get set }
    func connect(to peripheral: Peripheral)
}

protocol ScanUseCaseProtocol {
    var onPeripheralDiscovery: ((Peripheral) -> Void)? { get set }
    func scan(for services: [CBUUID])
}

protocol DisconnectUseCaseProtocol {
    var onDisconnection: ((Peripheral) -> Void)? { get set }
    func disconnect(from peripheral: Peripheral)
}

protocol ManagerStateUseCaseProtocol {
    var onCentralState: ((CBManagerState) -> Void)? { get set }
    func start()
}

typealias CentralManagerUseCaseProtocol = ConnectUseCaseProtocol & ScanUseCaseProtocol & ManagerStateUseCaseProtocol & DisconnectUseCaseProtocol

final class CentralUseCase: NSObject, CentralManagerUseCaseProtocol {
    
    var onPeripheralDiscovery: ((Peripheral) -> Void)?
    var onCentralState: ((CBManagerState) -> Void)?
    var onConnection: ((Peripheral) -> Void)?
    var onDisconnection: ((Peripheral) -> Void)?
    
    var central: CBCentralManager!
    
    func start() {
        central = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func scan(for services: [CBUUID]) {
        guard central.isScanning == false else {
            return
        }
        central.scanForPeripherals(withServices: services, options: [:])
    }
    
    func connect(to peripheral: Peripheral) {
        central.stopScan()
        central.connect(peripheral.cbPeripheral!)
    }
    
    func disconnect(from peripheral: Peripheral) {
        central.cancelPeripheralConnection(peripheral.cbPeripheral!)
    }
}

extension CentralUseCase: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        onCentralState?(central.state)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        onPeripheralDiscovery?(.init(cbPeripheral: peripheral))
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        onConnection?(.init(cbPeripheral: peripheral))
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        onDisconnection?(.init(cbPeripheral: peripheral))
    }
}

