//
//  ScanViewModel.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import Foundation
import CoreBluetooth

final class ScanViewModel: ObservableObject {
    @Published var state: State = .idle
    
    var foundPeripherals: Set<Peripheral> = []

    var useCase: CentralManagerUseCaseProtocol
    
    init(useCase: CentralManagerUseCaseProtocol) {
        self.useCase = useCase
        setCallbacks()
        self.useCase.start()
    }
    
    private func setCallbacks() {
        useCase.onConnection = { [weak self] peripheral in
            self?.state = .connected(peripheral)
        }
        
        useCase.onPeripheralDiscovery = { [weak self] peripheral in
            guard let self else {
                return
            }
            self.foundPeripherals.insert(peripheral)
            self.state = .scan(Array(self.foundPeripherals))
        }
        
        useCase.onCentralState = { [weak self] state in
            if state == .poweredOn {
                self?.state = .ready
            }
        }
        
        useCase.onDisconnection = { peripheral in
            print("Disconnect from peripheral \(peripheral)")
        }
    }
    
    // MARK: - From View to ViewModel
    func scan() {
        useCase.scan(for: [UUIDs.ledService])
    }
    
    func connect(to peripheral: Peripheral) {
        useCase.connect(to: peripheral)
    }
    
    func disconnectIfConnected() {
        guard case let .connected(peripheral) = state,
        peripheral.cbPeripheral != nil else {
            return
        }
        useCase.disconnect(from: peripheral)
    }
}

extension ScanViewModel {
    enum State {
        case idle
        case ready
        case scan([Peripheral])
        case connected(Peripheral)
    }
}
