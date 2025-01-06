//
//  MAinTabbarVC.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI

struct MAinTabbarVC: View {
    @State var presentSideMenu = false
    @State private var selectedView = 0
    @State private var navigationTitle = "HOME"
    // @State private var presentSideMenu = false
    //    init() {
    //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    //        UINavigationBar.appearance().shadowImage = UIImage()
    //        UINavigationBar.appearance().isTranslucent = true
    //        UINavigationBar.appearance().tintColor = .black
    //        UINavigationBar.appearance().backgroundColor = .clear
    //    }
    
    var body: some View {
        ZStack(){
            
            
            VStack(){
                NavBar(
                    title: navigationTitle,
                    leftButtonImage: "line.3.horizontal",
                    leftButtonAction: { print("line.3.horizontal") },
                    rightButtonImage: "bell",
                    rightButtonAction: { print("Bell clicked") }, presentSideMenu: $presentSideMenu
                )
                
                Spacer()
                TabView(selection: $selectedView) {
                    
                    NavigationView {
                        MainViewVC()
                            .onAppear {
                                navigationTitle = "HOME"
                            }
                    }
                    .tabItem {
                        Image.init("ic_home", tintColor: .clear)
                        Text("HOME")
                    }.tag(0)
                    
                    NavigationView {
                        ListView()
                            .onAppear {
                                navigationTitle = "FAVOURITE"
                            }
                    }
                    .tabItem {
                        Image.init("ic_favourite_tabbar", tintColor: .clear)
                        Text("FAVOURITE")
                    }.tag(1)
                    
                    NavigationView {
                        AllCartList()
                            .onAppear {
                                navigationTitle = "CARTS"
                            }
                    }
                    .tabItem {
                        Image.init("cart", tintColor: .clear)
                        Text("CARTS")
                    }.tag(2)
                    
                    NavigationView {
                        ListView()
                            .onAppear {
                                navigationTitle = "SAVED"
                            }
                    }
                    .tabItem {
                        Image.init("saved", tintColor: .clear)
                        Text("SAVED")
                    }.tag(3)
                }
                
                .onAppear(){
                    UITabBar.appearance().backgroundColor = UIColor(lightGreyColor)
                }
                .accentColor(lightblueColor)
            }
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedView, presentSideMenu: $presentSideMenu)))
        }
    }
    
}

struct TabbarVC_Previews: PreviewProvider {
    static var previews: some View {
        MAinTabbarVC()
    }
}

extension Image {
    init(_ named: String, tintColor: UIColor) {
        let uiImage = UIImage(named: named) ?? UIImage()
        let tintedImage = uiImage.withTintColor(tintColor,
                                                renderingMode: .alwaysTemplate)
        self = Image(uiImage: tintedImage)
    }
}
struct NavBar: View {
    
    var title: String
    var leftButtonImage: String
    var leftButtonAction: () -> Void
    var rightButtonImage: String
    var rightButtonAction: () -> Void
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                
                presentSideMenu.toggle()
                leftButtonAction()
            }) {
                Image(systemName: leftButtonImage)
                    .font(.system(size: 24, weight: .regular))
            }
            
            .accentColor(royalBlue)
            Spacer()
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("Text_whiteBlack"))
            Spacer()
            Button(action: rightButtonAction) {
                Image(systemName: rightButtonImage)
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(royalBlue)
        }
        .padding(16)
        .background(Color.white)
        .shadow(radius: 10)
    }
}
