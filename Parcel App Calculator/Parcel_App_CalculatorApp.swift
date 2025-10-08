//
//  Parcel_App_CalculatorApp.swift
//  Parcel App Calculator
//
//  Created by NAFIU AMOSA on 04/10/2025.
//

import SwiftUI
import SwiftData

@main
struct Parcel_App_CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: ParcelDataModel.self)
    }
}
