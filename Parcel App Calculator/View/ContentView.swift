//
//  ContentView.swift
//  Parcel App Calculator V2
//
//  Created by NAFIU AMOSA on 04/10/2025.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("weight") private var weight = ""
    @AppStorage("length") private var length = ""
    @AppStorage("width") private var width = ""
    @AppStorage("height") private var height = ""
    @AppStorage("resultMessage") private var resultMessage = "Package cost = 0"
    @AppStorage("postDate") private var postDate: Date = Date()
    @AppStorage("gVolume") private var gVolume = ""
    @AppStorage("gCost") private var gCost = ""
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
        
        ZStack(alignment: .top){
            
            // Apply fill background color to the top
            GeometryReader{
                geometry in
                Color.red
                    .frame(height: 140)
                    .ignoresSafeArea(.all, edges: .top)
            }
            
                
                
        VStack {
            // App Text
            HStack(alignment: .center){
                Image(systemName: "dollarsign.arrow.circlepath")
                    .bold()
                    .font(.title)
                    .imageScale(.large)
                    .foregroundStyle(.black)
                    .frame(alignment:.center)
                Text("📦 Parcel Cost Calculator")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
            }
            
            
            // Toggle Button
            Toggle(isOn: $useAdvancedPricing){
                Text("Use Advanced Pricing")
            }.toggleStyle(SwitchToggleStyle(tint: .green))
                .onTapGesture {
                    resultMessage = "Package cost = 0"
                }
            
            // DatePicker
            DatePicker("Select date", selection: $postDate, in: ...Date(),
                       displayedComponents: .date
            )
            
            
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
                calculatePostage(useAdvancedPricing: useAdvancedPricing)
                
                
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
        
        
    }
    
    // Function to Calculator Postage
    func calculatePostage(useAdvancedPricing: Bool) {
        // 1. Input Validation: Attempt to safely get Double values for calculations.
        // The same validation is needed for both pricing methods.
        guard let weightValue = Double(weight),
              let lengthValue = Double(length),
              let widthValue = Double(width),
              let heightValue = Double(height),
              weightValue > 0, lengthValue > 0, widthValue > 0, heightValue > 0 else {
            resultMessage = "Error! Empty field or wrong entry"
            isError = true
            return
        }

        var totalCost: Double
        let volume = heightValue * lengthValue * widthValue

        // 2. Logic Separation: Use the boolean flag to branch the pricing logic.
        if useAdvancedPricing {
            // Advanced Pricing Logic
            guard weightValue <= 30, lengthValue <= 150, widthValue <= 150, heightValue <= 150 else {
                resultMessage = "Error! Wrong value entered for advanced pricing."
                isError = true
                return
            }
            
            totalCost = 2.50
            let dimensionalWeight = volume / 5000
            let chargeableWeight = max(dimensionalWeight, weightValue)
            totalCost += (chargeableWeight * 1.50) + (dimensionalWeight * 0.75)
            
            var surchargeFactor: Double = 1.0
            if weightValue > 20.0 {
                surchargeFactor = 1.5
            } else if weightValue > 10.0 { // Corrected: original had a typo (&& weightValue < 20.0)
                surchargeFactor = 1.25
            }
            totalCost += surchargeFactor
            totalCost = max(totalCost, 5.00)
        } else {
            // Standard Pricing Logic
            totalCost = 3.00
            totalCost += weightValue * 0.50
            totalCost += (volume / 1000) * 0.10
            totalCost = max(totalCost, 4.00)
            
           
        }

        // 4. Common Output: Update the UI once, after all calculations are complete.
        // 3. Database operation: Only happens with the standard calculator.
        let newRecord = ParcelDataModel(weight: String(weight), volume: String(volume), cost: String(totalCost), postDate: postDate)
        modelContext.insert(newRecord)
        gCost = String(totalCost)
        gVolume = String(volume)
        resultMessage = String(format: "Package cost = £%.2f", totalCost)
        isError = false
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
    
   
    
    // Function for over scaling measurement error
    private func measurementErrorMessage(measureValue: String, measureTool: String){
        if useAdvancedPricing{
            if let lengthValue = Double(measureValue), lengthValue > 150.0{
                resultMessage = "Max \(measureTool) Dimension: 150cm"
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
