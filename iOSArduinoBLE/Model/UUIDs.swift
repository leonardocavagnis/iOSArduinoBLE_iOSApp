//
//  UUIDs.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import Foundation
import CoreBluetooth

enum UUIDs {
    static let ledService = CBUUID(string: "cd48409a-f3cc-11ed-a05b-0242ac120003")
    static let ledStatusCharacteristic = CBUUID(string:  "cd48409b-f3cc-11ed-a05b-0242ac120003") // Write
    
    static let sensorService = CBUUID(string: "d888a9c2-f3cc-11ed-a05b-0242ac120003")
    static let temperatureCharacteristic = CBUUID(string:  "d888a9c3-f3cc-11ed-a05b-0242ac120003") // Read | Notify
}
