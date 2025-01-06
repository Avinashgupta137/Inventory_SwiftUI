//
//  ContentView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 12/12/24.
//

import SwiftUI


let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
let lightGreenColor = Color(red: 21.0/255.0, green: 183.0/255.0, blue: 177.0/255.0, opacity: 1.0)
let lightblueColor = Color(red: 85.0/255.0, green: 84.0/255.0, blue: 166.0/255.0, opacity: 1.0)

let royalBlue = Color(red: 65.0/255.0, green: 105.0/255.0, blue: 225.0/255.0, opacity: 1.0)



func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"  
    return formatter.string(from: date)
}
