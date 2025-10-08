//
//  ParcelDataModel.swift
//  Parcel App Calculator
//
//  Created by NAFIU AMOSA on 08/10/2025.
//

import Foundation
import SwiftData

@Model
class ParcelDataModel{
    var weight: String
    var volume: String
    var cost: String
    var postDate: Date
    
    init(weight: String, volume: String, cost: String, postDate: Date) {
        self.weight = weight
        self.volume = volume
        self.cost = cost
        self.postDate = postDate
    }
}
