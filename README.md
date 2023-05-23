# iOSArduinoBLE iOS App

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![SwiftUI Version](https://img.shields.io/badge/SwiftUI-2.0-green.svg)](https://developer.apple.com/documentation/swiftui)
[![Xcode Version](https://img.shields.io/badge/Xcode-14.3-blue.svg)](https://developer.apple.com/xcode/)

## Description

This repository contains an iOS app called iOSArduinoBLE that enables scanning and connecting to a Bluetooth Low Energy (BLE) peripheral device that exposes a specific service in its advertising. The app consists of two main screens: Scan and Connect.

- The "Scan" screen enables searching for and displaying available BLE devices in the surrounding area. Once the desired device is found, you can initiate a connection to it.
- The "Connect" screen provides an interface to interact with the characteristics of the peripheral device. The app supports two types of characteristics:
  - Read and Notify characteristic: Allows reading data from the characteristic and receiving notifications when the data is updated.
  - Write characteristic: Enables sending data to the peripheral device.

The app is based on the [CoreBluetooth](https://developer.apple.com/documentation/corebluetooth) framework in iOS for managing Bluetooth connectivity.

For detailed usage and functionality of the app, it is recommended to refer to the external article [here](link_to_article) that provides a comprehensive explanation.

## BLE Characteristics

The app supports the following BLE characteristics:

| Characteristic           | UUID                                     | Service                                   |
| ------------------------ | ---------------------------------------- | ----------------------------------------- |
| Read and Notify           | `d888a9c3-f3cc-11ed-a05b-0242ac120003`   | `d888a9c2-f3cc-11ed-a05b-0242ac120003`   |
| Write                     | `cd48409b-f3cc-11ed-a05b-0242ac120003`   | `cd48409a-f3cc-11ed-a05b-0242ac120003`   |

Please refer to the documentation for more details on how to interact with these characteristics.

## Languages, Tools, and Environment

- Swift 5.0
- SwiftUI
- Xcode 14.3

## Authors

This project was developed by:
- [Leonardo Cavagnis](https://github.com/leonardocavagnis)
- [Andrea Finollo](https://github.com/DrAma999)
