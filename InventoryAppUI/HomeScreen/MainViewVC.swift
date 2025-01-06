//
//  MainViewVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//
import SwiftUI

struct MainViewVC: View {
    @State private var items: [Datas] = []
    @State private var isLoading = true
    @State private var addedToCart: [Bool] = [] // Track "Add to Cart" state for each item
    @State private var itemCounts: [Int] = []  // Track counts for each item
    @State private var searchText: String = ""
    
    var filteredItems: [Datas] {
           if searchText.isEmpty {
               return items
           } else {
               return items.filter {
                   $0.iTEM_NAME?.localizedCaseInsensitiveContains(searchText) ?? false
               }
           }
       }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                TextField("Search items...", text: $searchText)
                                       .padding(10)
                                       .background(Color(.systemGray6))
                                       .cornerRadius(8)
                                       .padding(.horizontal)
                
                List(filteredItems.indices, id: \.self) { index in
                    ItemDetailCell(
                        itemMasterId: filteredItems[index].iTEM_MASTER_ID,
                        itemName: filteredItems[index].iTEM_NAME ?? "Unknown",
                        itemDetail: "Brand: \(filteredItems[index].bRAND ?? "Unknown"), Model: \(filteredItems[index].mODEL_NO ?? "Unknown")",
                        itemDesc: filteredItems[index].sR_NUMBER,
                        itemCounts: $itemCounts[index], // Pass as binding
                        isAddToCartButtonVisible: Binding(
                            get: { filteredItems[index].items_in_cart ?? 0 },
                            set: { newValue in
                                if let itemIndex = items.firstIndex(where: { $0.iTEM_MASTER_ID == filteredItems[index].iTEM_MASTER_ID }) {
                                    items[itemIndex].items_in_cart = newValue
                                } }),
                        isCheckboxVisible: false,
                        itemImageURL: filteredItems[index].iTEM_THUMBNAIL,
                        onAddToCart: {
                            addedToCart[index] = true
                            print("Added to cart: \(filteredItems[index].iTEM_NAME ?? "Unknown")")
                        },
                        onCountChanged: { newCount in
                            itemCounts[index] = newCount
                            print("Updated count for \(filteredItems[index].iTEM_NAME ?? "Unknown"): \(newCount)")
                        },
                        hideDeleteButton: true, onDelete: {}, onCheckUncheck: {}
                    )
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 5)
                }

                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            getMemberDetail()
        }
    }
    
    func getMemberDetail() {
        let parameters: [String: Any] = ["emp_code": "SANS-00290"]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getAllItem,
            method: .post,
            param: parameters,
            model: GetAllItem.self
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.items = data
                        self.addedToCart = Array(repeating: false, count: data.count)
                        self.itemCounts = Array(repeating: 1, count: data.count) // Initialize with 1
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
