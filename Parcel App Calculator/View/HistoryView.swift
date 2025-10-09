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
                HStack(alignment: .center){
                    Image(systemName: "cube.box")
                        .foregroundColor(.blue)
                        .font(.title)
                    Spacer()
                    VStack(alignment: .leading){
                        Text(parcel.postDate, style: .date)
                            .font(.headline)
                            .padding(.bottom, 5)
                        Image(systemName: "scalemass")
                        Text("\(parcel.weight) kg")
                        Image(systemName: "box")
                        Text("\(parcel.volume) cm³")
                    }
                    
                    Spacer()
                    Text("$ \(parcel.cost)").font(.title2).fontWeight(.bold).foregroundColor(.blue)
                }
                
            }
        }.padding(.vertical, 5)
            .navigationTitle("Calculation History")
    }
}

#Preview {
    HistoryView()
}
