//
//  CovidStatisticType.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import Foundation


enum CovidStatisticType: String, CustomStringConvertible {
    case avarageCases = "cases / day"
    case averageDeaths = "deaths / day"
    
    var description: String {
        return self.rawValue.capitalized
    }
    
    var compactDescription: String {
        switch self {
        case .avarageCases:
            return "cases"
        case.averageDeaths:
            return "deaths"
        }
    }
    
    init(intentStatisticRawValue: Int) {
        switch intentStatisticRawValue {
        case 1:
            self = CovidStatisticType.avarageCases
        case 2:
            self = CovidStatisticType.averageDeaths
        default:
            self = CovidStatisticType.averageDeaths
        }
    }
    
}
