//
//  ScanView.swift
//  iOSArduinoBLE
//
//  Authors: Andrea Finollo, Leonardo Cavagnis
//

import SwiftUI
import CoreBluetooth

struct ScanView: View {
    @ObservedObject var viewModel: ScanViewModel
    
    @State var shouldShowDetail = false
    @State var peripheralList = [Peripheral]()
    @State var isScanButtonEnabled = false
    
    var body: some View {
        VStack{
            List(peripheralList, id: \.id) { peripheral  in
                Text("\(peripheral.name ?? "N/A")")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        viewModel.connect(to: peripheral)
                    }
            }
            .listStyle(.plain)
            Spacer()
            Button {
                viewModel.scan()
            } label: {
                Text("Start Scan")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!isScanButtonEnabled)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .onReceive(viewModel.$state) { state in
            switch state {
            case .connected:
                shouldShowDetail = true
            case .scan(let list):
                peripheralList = list
            case .ready:
                isScanButtonEnabled = true
            default:
                print("Not handled")
            }
        }
        .navigationTitle("Scan list")
        .navigationDestination(isPresented: $shouldShowDetail) {
            if case let .connected(peripheral) = viewModel.state  {
                let viewModel = ConnectViewModel(useCase: PeripheralUseCase(),
                    connectedPeripheral:peripheral)
                ConnectView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.disconnectIfConnected()
        }
    }
}

struct ScanAndConnectView_Previews: PreviewProvider {
    
    final class FakeUseCase: CentralManagerUseCaseProtocol {
        
        var onPeripheralDiscovery: ((Peripheral) -> Void)?
        
        var onCentralState: ((CBManagerState) -> Void)?
        
        var onConnection: ((Peripheral) -> Void)?
        
        var onDisconnection: ((Peripheral) -> Void)?
        
        func start() {
            onCentralState?(.poweredOn)
        }
        
        func scan(for services: [CBUUID]) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.onPeripheralDiscovery?(Peripheral(name: "iOSArduinoBoard_1"))
                self.onPeripheralDiscovery?(Peripheral(name: "iOSArduinoBoard_2"))
            }
        }
        
        func connect(to peripheral: Peripheral) {
            print("Connecting")
            onConnection?(.init(name: "iOSArduinoBoard_1"))
        }
        
        func disconnect(from peripheral: Peripheral) {
            onDisconnection?(.init(name: "iOSArduinoBoard_1"))
        }
        
    }
    
    static var viewModel = {
        ScanViewModel(useCase: FakeUseCase())
    }()
    
    static var previews: some View {
        NavigationStack {
            ScanView(viewModel: viewModel)
        }
    }
}
