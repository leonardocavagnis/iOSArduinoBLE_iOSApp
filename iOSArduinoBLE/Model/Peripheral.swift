//
//  Peripheral.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import Foundation
import CoreBluetooth


struct Peripheral: Identifiable, Equatable, Hashable {
    var cbPeripheral: CBPeripheral?
    let name: String?
    let id: UUID
    
    init(name: String) {
        self.name = name
        self.id = UUID()
    }
    
    init(cbPeripheral: CBPeripheral) {
        self.cbPeripheral = cbPeripheral
        self.id = cbPeripheral.identifier
        self.name = cbPeripheral.name
    }
}

