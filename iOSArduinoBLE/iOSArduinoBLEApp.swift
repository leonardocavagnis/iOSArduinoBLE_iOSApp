//
//  iOSArduinoBLEApp.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import SwiftUI

@main
struct iOSArduinoBLEApp: App {
    
    @StateObject var viewModel = ScanViewModel(useCase: CentralUseCase())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScanView(viewModel: viewModel)
            }
        }
    }
}
