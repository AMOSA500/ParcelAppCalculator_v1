//
//  MainTabView.swift
//  Parcel App Calculator
//
//  Created by NAFIU AMOSA on 08/10/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            ContentView()
                .tabItem{
                    Label("Calculator", systemImage: "function")
                }
            HistoryView()
                .tabItem{
                    Label("History", systemImage: "clock")
                }
        }
    }
}

#Preview {
    MainTabView()
}
