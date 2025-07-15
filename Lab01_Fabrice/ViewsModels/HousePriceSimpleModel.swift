//
//  HousePriceSimpleModel.swift
//  Lab01_Fabrice
//
//  Created by Fabrice Kouonang on 2025-07-14.
//

import Foundation
import CoreML
import Observation
@Observable
class HousePriceSimpleModel {
    var bedrooms: Double=0
    var predictedPrice: Double?
    private var model: HousePriceSimple?
    init(){
        do {
            self.model = try HousePriceSimple(configuration: .init())
        }
        catch {
            print("Error loading model: \(error)")
        }
    }
    func predictPrice() {
        guard let model = model else { return }
        
        do {
            let input=HousePriceSimpleInput(bedrooms: bedrooms)
            let prediction = try model.prediction(input: input)
            self.predictedPrice = prediction.price
        }
            catch {
                print("Error predicting: \(error)")
        }
    }
}
