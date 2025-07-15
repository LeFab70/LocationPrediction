//
//  HousePriceMultiModels.swift
//  Lab01_Fabrice
//
//  Created by Fabrice Kouonang on 2025-07-14.
//

import Foundation
import CoreML
import Observation

@Observable
class HousePriceMultiModels{
    var bedrooms:Double = 0
    var bathrooms:Double = 0
    var city:String = "Seattle"
    var predictedPrice:Double?
    private var model:HousePriceMulti?
    init(){
        do {
            model = try HousePriceMulti(configuration: .init())
        } catch {
            print("Error loading model: \(error)")
        }
    }
    
    func predictPrice(){
        guard let model = model else { return }
       
        do {
            let input = HousePriceMultiInput(bedrooms: bedrooms, bathrooms: bathrooms, city: city)
            let prediction = try model.prediction(input: input)
            self.predictedPrice = prediction.price
        } catch {
            print("Error predicting: \(error)")
        }
    }
    
    
}
