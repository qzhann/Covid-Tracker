//
//  StatisticType.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import Foundation


enum StatisticType: String, CustomStringConvertible {
    case avarageCases = "cases per day"
    case averageDeaths = "deaths per day"
    
    var description: String {
        return self.rawValue.capitalized
    }
    
    init(intentStatisticRawValue: Int) {
        switch intentStatisticRawValue {
        case 1:
            self = StatisticType.avarageCases
        case 2:
            self = StatisticType.averageDeaths
        default:
            self = StatisticType.averageDeaths
        }
    }
    
}
