//
//  HistoryView.swift
//  Parcel App Calculator
//
//  Created by NAFIU AMOSA on 08/10/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var parcels: [ParcelDataModel]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(parcels) {
                    parcel in
                    HStack(alignment: .center){
                        ZStack(alignment: .center){
                            Image(systemName: "cube.box")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                       
                       
                        VStack(alignment: .leading){
                            HStack(alignment: .center, spacing: 2){
                                Image(systemName: "ruler").foregroundColor(Color.blue)
                                Text(parcel.postDate, style: .date)
                            }
                            
                            HStack(alignment: .center, spacing: 2){
                                Image(systemName: "scalemass").foregroundColor(Color.yellow)
                                Text("\(parcel.weight) kg").fontWeight(.light)
                                Spacer()
                                Image(systemName: "cube.box").foregroundColor(Color.green)
                                Text("\(parcel.volume) cm³").font(.footnote)
                                Spacer()
                            }
                            
                        }
                        
                        
                        Text("£\(parcel.cost)").fontWeight(.bold).foregroundColor(.blue)
                    }.frame(maxWidth: .infinity)
                    
                }.onDelete(perform: funcDeleteParcel)
            }.navigationTitle("Parcel History")
             .navigationBarTitleDisplayMode(.inline)
                
        }
        .padding(.vertical, 5)
            
    }
    
    func funcDeleteParcel(at offsets: IndexSet){
        for offset in offsets{
            let offset = parcels[offset]
            modelContext.delete(offset)
        }
        
    }
}

#Preview {
    HistoryView()
}
