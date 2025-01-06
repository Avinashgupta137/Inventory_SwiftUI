//
//  ToastManager.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 04/01/25.
//

import SwiftUI

class ToastManager: ObservableObject {
    static let shared = ToastManager()

    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""

    private init() {}

    func show(message: String) {
        toastMessage = message
        showToast = true

        // Hide toast after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.showToast = false
            }
        }
    }
}

struct ToastView: View {
    @ObservedObject var toastManager = ToastManager.shared

    @State private var offset: CGFloat = -50 

    var body: some View {
        ZStack {
            if toastManager.showToast {
                Text(toastManager.toastMessage)
                    .font(.headline)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .transition(.opacity)
                    .offset(y: offset)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            self.offset = 30
                        }
                    }
                    .onDisappear {
                        self.offset = -100
                    }
            }
        }
        .animation(.easeInOut, value: toastManager.showToast)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, -40)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button("Show Toast") {
                    ToastManager.shared.show(message: "This is a Toast message!")
                }
                .navigationBarTitle("Navigation Bar", displayMode: .inline)
                Spacer()
            }
            .overlay(ToastView())
        }
    }
}
