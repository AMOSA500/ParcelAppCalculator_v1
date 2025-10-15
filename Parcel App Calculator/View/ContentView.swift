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
    @State var resultMessage = "Package cost = £0"
    @AppStorage("postDate") private var postDate: Date = Date()
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
                    resultMessage = "Package cost = £0"
                }
            
            // DatePicker
            DatePicker("Select date", selection: $postDate, in: ...Date(),
                       displayedComponents: .date
            )
            
            
            // Stact for weight
            InputView(value: $weight, resultMessage: $resultMessage, label: "Weight (Kg): ", useAdvancedPricing: $useAdvancedPricing, isError: $isError)
            
            // State for length
            InputView(value: $length, resultMessage: $resultMessage, label: "Length (cm): ", useAdvancedPricing: $useAdvancedPricing, isError: $isError)

            
            // Stact for Width
            
            
            InputView(value: $width, resultMessage: $resultMessage, label: "Width (cm): ", useAdvancedPricing: $useAdvancedPricing, isError: $isError)
            // Stack for Height
            
            InputView(value: $height, resultMessage: $resultMessage, label: "Height (cm): ", useAdvancedPricing: $useAdvancedPricing, isError: $isError)
            // Display Text Are
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
            Button("Clear"){
                weight = ""
                height = ""
                length = ""
                width = ""
                resultMessage = "Package cost = £0"

            }
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
                resultMessage = "Error! Over weight value entered."
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
            } else if weightValue > 10.0 {
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

       
        let newRecord = ParcelDataModel(weight: String(weight), volume: String(volume), cost: String(format: "%.2f", totalCost), postDate: postDate)
        modelContext.insert(newRecord)
        resultMessage = String(format: "Package cost = £%.2f", totalCost)
        isError = false
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

#Preview {
    ContentView()
}
