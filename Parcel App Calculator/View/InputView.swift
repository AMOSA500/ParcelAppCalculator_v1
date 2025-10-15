//
//  InputView2.swift
//  Parcel App Calculator
//
//  Created by Nafiu Amosa on 15/10/2025.
//

import Foundation
import SwiftUI

struct InputView: View{
    @Binding var value: String
    @Binding var resultMessage: String
    let label: String
    let useAdvancedPricing: Bool
    @State var isError: Bool
    
    var body: some View{
        HStack(alignment: .center, spacing: 20){
            Label(label, systemImage: "")
                .labelStyle(.titleOnly)
                .frame(width: 70, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            TextField("0", text: $value)
                .bold()
                .font(.largeTitle)
                .padding(.horizontal, 15)
                .cornerRadius(8)
                .background(Color.gray.opacity(0.2))
                .keyboardType(.decimalPad)
                .onChange(of: value){
                    oldValue, newValue in
                    funcfilterNumbericInput(for: $value, oldValue: oldValue, newValue: newValue)
                    measurementErrorMessage(measureValue: value, measureTool: label)
                    
                    
                }
        }.padding(.vertical, 20)
        
    }
    
    // Function to manually control numberic digits only
    private func funcfilterNumbericInput(for binding: Binding<String>, oldValue:String, newValue:String){
        var filtered = newValue.filter{"0123456789.".contains($0)}
        if filtered.filter({$0 == "."}).count > 1 {
            filtered = oldValue
        }
        if filtered != newValue{
            binding.wrappedValue = filtered
        }
        
    }
    
   
    
    // Function for over scaling measurement error
    private func measurementErrorMessage(measureValue: String, measureTool: String){
        if useAdvancedPricing{
            if let lengthValue = Double(measureValue), lengthValue > 150.0{
                resultMessage = "Max \(measureTool) Dimension: 150cm"
                isError = true;
            }else{
                resultMessage = "Package cost = £0"
                isError = false
            }
        }
    }
    
    
}
