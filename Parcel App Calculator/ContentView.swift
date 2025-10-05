//
//  ContentView.swift
//  Parcel App Calculator V2
//
//  Created by NAFIU AMOSA on 04/10/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var weight = ""
    @State private var length = ""
    @State private var width = ""
    @State private var height = ""
    @State private var resultMessage = "Package cost = 0"
    @State private var isError = false
    @State private var useAdvancedPricing = false
    
    private var displayResult: some View{
        Text(resultMessage)
            .bold()
            .foregroundStyle(isError ? .red: .primary)
        
    }
    
    private var isDisabled: Bool {
        weight.isEmpty || length.isEmpty || width.isEmpty || height.isEmpty
    }
    
    
    var body: some View {
        // App Text
        HStack(alignment: .center){
            Image(systemName: "dollarsign.arrow.circlepath")
                .bold()
                .font(.title)
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(alignment:.center)
            Text("Parcel Cost Calculator 📦")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
            .frame(maxWidth: .infinity)
            .background(.red)
            
        VStack {
            // Toggle Button
            Toggle(isOn: $useAdvancedPricing){
                Text("Use Advanced Pricing")
            }.toggleStyle(SwitchToggleStyle(tint: .green))
                .onTapGesture {
                resultMessage = "Package cost = 0"
            }
            
            
            // Stact for weight
            HStack(alignment: .center, spacing: 20){
                Label("Weight (Kg): ", systemImage: "scale.3d")
                    .labelStyle(.titleOnly)
                    .frame(width: 70, alignment: .leading)
                TextField("0", text: $weight)
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 15)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))
                    .keyboardType(.decimalPad)
                    .onChange(of: weight){
                        oldValue, newValue in
                        funfilterNumbericInput(for: $weight, oldValue: oldValue, newValue: newValue)
                        if useAdvancedPricing{
                            if let weightValue = Double(weight),
                               weightValue > 30.0{
                                resultMessage = "Max weight: 30Kg"
                                isError = true;
                            }else{
                                resultMessage = "Package cost = 0"
                                isError = false
                            }
                        }
                        
                    }
            }.padding(.vertical, 20)
            
            // State for length
            HStack(alignment: .center, spacing: 20){
                Label("Length (cm): ", systemImage: "ruler")
                    .labelStyle(.titleOnly)
                    .frame(width: 70, alignment: .leading)
                TextField("0", text: $length)
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 15)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))
                    .keyboardType(.decimalPad)
                    .onChange(of: length){
                        oldValue, newValue in
                        funfilterNumbericInput(for: $length, oldValue: oldValue, newValue: newValue)
                        measurementErrorMessage(measureValue: length, measureTool: "length")

                    }
            }.padding(.vertical, 20)
            
            // Stact for Width
            HStack(alignment: .center, spacing: 20){
                Label("Width (cm): ", systemImage: "scalemass")
                    .labelStyle(.titleOnly)
                    .frame(width: 70, alignment: .leading)
                TextField("0", text: $width)
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 15)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))
                    .keyboardType(.decimalPad)
                    .onChange(of: width){
                        oldValue, newValue in
                        funfilterNumbericInput(for: $width, oldValue: oldValue, newValue: newValue)
                        measurementErrorMessage(measureValue: width, measureTool: "width")
                    }
            }.padding(.vertical, 20)
            
            // Stack for Height
            HStack(alignment: .center, spacing: 20){
                Label("Height (cm): ", systemImage: "ruler")
                    .labelStyle(.titleOnly)
                    .frame(width: 70, alignment: .leading)
                TextField("0", text: $height)
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 15)
                    .cornerRadius(8)
                    .background(Color.gray.opacity(0.2))
                    .keyboardType(.decimalPad)
                    .onChange(of: height){
                        oldValue, newValue in
                        funfilterNumbericInput(for: $height, oldValue: oldValue, newValue: newValue)
                        measurementErrorMessage(measureValue: height, measureTool: "height")
                    }
            }.padding(.vertical, 20)
            
            // Display Text Area
            Spacer()
            displayResult.padding()
            Button("Calculate Cost"){
                
                print("Parcel Data: ")
                print("Weight: \(weight)")
                print("Length: \(length)")
                print("width: \(width)")
                print("Height \(height)")
                
                // Function call
                useAdvancedPricing ? funcUseAdvancedPricing() : postageCalculator()
                
            }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical,16)
                .font(.system(size: 24))
                .foregroundStyle(.white)
                .background(isDisabled ? .gray.opacity(0.3) : .black)
                .cornerRadius(10)
                .disabled(isDisabled)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    
    // Function to Calculator
    func postageCalculator() {
        if let weightValue = Double(weight),
           let lengthValue = Double(length),
           let widthValue = Double(width),
           let heightValue = Double(height),
           weightValue > 0, lengthValue > 0, widthValue > 0, heightValue > 0{
            let volume = heightValue * lengthValue * widthValue
            var totalCost = 3.00 // Base cost
            totalCost += weightValue * 0.50 // Weight charge
            totalCost += (volume / 1000) * 0.10 // Volume charge
            totalCost = max(totalCost, 4.00)
            resultMessage = String(format: "Package cost = £%.2f", totalCost)
            isError = false
            
        }else{
            resultMessage = "Error! Empty field or wrong entry"
            isError = true
        }
    }
    
    // Function to manually control numberic digits only
    private func funfilterNumbericInput(for binding: Binding<String>, oldValue:String, newValue:String){
        var filtered = newValue.filter{"0123456789.".contains($0)}
        if filtered.filter({$0 == "."}).count > 1 {
            filtered = oldValue
        }
        if filtered != newValue{
            binding.wrappedValue = filtered
        }
        
    }
    
    // Function for Advance Pricing
    private func funcUseAdvancedPricing(){
        guard let weightValue = Double(weight),
              let lengthValue = Double(length),
              let widthValue = Double(width),
              let heightValue = Double(height),
              (weightValue > 0 && weightValue <= 30), (lengthValue > 0 && lengthValue <= 150), (widthValue > 0 && widthValue <= 150), (heightValue > 0 && heightValue <= 150) else{
                resultMessage = "Error! Empty field or wrong value entered"
                isError = true
                return
        }
        var totalCost = 2.50 // Base cost
        let volume = lengthValue * widthValue * heightValue
        let dimensionalWeight = volume / 5000
        let chargeableWeight = dimensionalWeight > weightValue ? dimensionalWeight : weightValue
        totalCost += (chargeableWeight * 1.50) + (dimensionalWeight * 0.75) // base cost
        var surchargeFactor: Double = 1.0
        if weightValue > 20.0{
            surchargeFactor = 1.5
        }else if weightValue > 10.0 && weightValue < 20.0{
            surchargeFactor = 1.25
        }
        totalCost += surchargeFactor
        totalCost = max(totalCost, 5.00)
        resultMessage = String(format: "Package cost = £%.2f", totalCost)
        isError = false
    }
    
    // Function for over scaling measurement error
    private func measurementErrorMessage(measureValue: String, measureTool: String){
        if useAdvancedPricing{
            if let lengthValue = Double(length), lengthValue > 150.0{
                resultMessage = "Max Length Dimension: 150cm"
                isError = true;
            }else{
                resultMessage = "Package cost = 0"
                isError = false
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
