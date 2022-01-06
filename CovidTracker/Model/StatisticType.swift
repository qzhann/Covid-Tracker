//
//  StatisticType.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import Foundation


enum StatisticType: String, CustomStringConvertible {
    case avarageCases = "cases"
    case averageDeaths = "deaths"
    
    var description: String {
        return self.rawValue.capitalized
    }
    
}
