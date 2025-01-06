//
//  AllCartList.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 13/12/24.
//

import SwiftUI
import VisionKit

struct AllCartList: View {
    @State private var items: [CartList] = []
    @State private var isLoading = true
    @State private var showPopup = false
    @State private var showDateilScreen = false
    
    @State var isShowingScanner = false
    @State private var scannedText = ""
    @State private var checkedStates: [String?] = []
    
    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Date()    
    @State private var isFromDatePickerVisible: Bool = false
    @State private var isToDatePickerVisible: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        HStack {
                            Button(action: {
                                showPopup = true
                            }) {
                                Text("\(formattedDate(fromDate))")
                                    .font(.headline)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }

                            if isFromDatePickerVisible {
                                DatePicker(
                                    "",
                                    selection: $fromDate,
                                    in: Date()...,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .padding(10)
                            }

                            Button(action: {
                                showPopup = true
                            }) {
                                Text("\(formattedDate(toDate))")
                                    .font(.headline)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.1))
                                    .foregroundColor(.green)
                                    .cornerRadius(8)
                            }

                            if isToDatePickerVisible {
                                DatePicker(
                                    "",
                                    selection: $toDate,
                                    in: fromDate...,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                                .padding(10)
                            }
                            
                            Button(action: {
                                if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                                    isShowingScanner = true
                                } else {
                                    print("Scanner is not supported or available")
                                }
                            }) {
                                HStack {
                                    Image(systemName: "qrcode.viewfinder")
                                }
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                            }
                            .padding(2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        List(items, id: \.id) { item in
                            ItemDetailCell(
                                itemMasterId: item.iTEM_MASTER_ID,
                                itemName: item.iTEM_NAME ?? "Unknown",
                                itemDetail: "Brand: \(item.bRAND ?? "Unknown"), Model: \(item.mODEL_NO ?? "Unknown")",
                                itemDesc: item.sR_NUMBER ?? "N/A",
                                itemCounts: .constant(item.items_in_cart ?? 0),
                                isAddToCartButtonVisible: .constant(item.items_in_cart ?? 0),
                                isCheckboxVisible: true,
                                itemImageURL: item.iTEM_THUMBNAIL ?? "",
                                onAddToCart: {},
                                onCountChanged: { _ in },
                                hideDeleteButton: false,
                                onDelete: {
                                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                                        items.remove(at: index)
                                    }
                                    getMemberDetail()
                                },
                                onCheckUncheck : {
                                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                                        if let existingIndex = checkedStates.firstIndex(of: item.id) {
                                            checkedStates.remove(at: existingIndex)
                                        } else {
                                            checkedStates.append(item.id)
                                        }
                                        print("Selected IDs: \(checkedStates)")
                                    }

                                }
                            )
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 5)
                        }
                        .listStyle(PlainListStyle())
                    }
                    HStack {
                        if !checkedStates.isEmpty {
                            Button(action: {
                                showPopup = true
                            }) {
                                Text("Continue")
                            }
                            .font(.headline)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(5)
                }
                if showPopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showPopup = false
                            }
                        SelectDatePopUp(
                            showPopup: $showPopup,
                            onSubmit: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    showDateilScreen = true
                                }
                            }, checkedStates: checkedStates.map { $0 ?? "" },
                            fromDate: $fromDate,
                            toDate: $toDate
                        )
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showPopup)
                }
            }
            .fullScreenCover(isPresented: $showDateilScreen) {
                EnterDetailsVC()
            }
            
            .fullScreenCover(isPresented: $isShowingScanner) {
                QRScannerView(isShowingScanner: $isShowingScanner, scannedText: $scannedText)
            }
            
        }
        .onAppear {
            getMemberDetail()
        }
    }
    
    func getMemberDetail() {
        let parameters: [String: Any] = ["emp_code": "1"]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.allcartlist,
            method: .post,
            param: parameters,
            model: GetAllCartList.self
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.items = data
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    self.items = []
                    print("API Error: \(error)")
                }
            }
        }
    }
    
}
