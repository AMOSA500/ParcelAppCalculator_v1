//
//  HistoryView.swift
//  Parcel App Calculator
//
//  Created by NAFIU AMOSA on 08/10/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query var parcels: [ParcelDataModel]
    
    var body: some View {
        NavigationStack{
            List(parcels) {parcel in
                Text(parcel.postDate, format: Date.FormatStyle().day().month().year())
                Text(parcel.weight)
                Text(parcel.volume)
                Text(parcel.cost)
            }
        }.padding(.vertical, 5)
            .navigationTitle("Calculation History")
    }
}

#Preview {
    HistoryView()
}
