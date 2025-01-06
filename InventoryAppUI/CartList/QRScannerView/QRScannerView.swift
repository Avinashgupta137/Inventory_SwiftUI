//
//  QRScannerView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 30/12/24.
//

import SwiftUI
import VisionKit

struct QRScannerView: View {
    @Binding var isShowingScanner: Bool
    @Binding var scannedText: String
    
    @State private var showAddButton: Bool = false // Track when to show the "Add Item" button
    
    var body: some View {
        NavigationView {
            VStack {
                if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                    ZStack {
                        // Scanner view restricted to a frame
                        DataScannerRepresentable(
                            shouldStartScanning: .constant(true),
                            scannedText: $scannedText,
                            dataToScanFor: [.barcode(symbologies: [.qr])]
                        )
                        .onChange(of: scannedText) { newValue in
                            if !newValue.isEmpty {
                                showAddButton = true
                            }
                        }
                        .frame(width: 300, height: 300) // Adjust the scanner frame
                        .border(Color.gray, width: 2) // Optional border for the scanner frame
                    }
                    
                    // Add Item button displayed beneath the scanner frame
                    if showAddButton {
                        Button(action: {
                            // Handle "Add Item" button tap
                            print("Scanned Text: \(scannedText)")
                            addQRItemDetail()
                        }) {
                            Text("Add Item")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                } else {
                    // Message if the scanner is unavailable
                    Text("Scanner not available or supported")
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("QR Scanner")
            .navigationBarItems(trailing: Button("Close") {
                isShowingScanner = false
            })
        }
    }
    func addQRItemDetail() {
        let parameters: [String: Any] = ["emp_code": "1","item_qr_string": "\(scannedText)"]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.addToCartByItemQr,
            method: .post,
            param: parameters,
            model: GetAllCartList.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
}
