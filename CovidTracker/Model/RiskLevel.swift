//
//  RiskLevel.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import Foundation
import SwiftUI

enum RiskLevel {
    case safe
    case low
    case medium
    case high
    case extreme
    
    var color: Color {
        switch self {
        case .safe:
            return .green
        case .low:
            return .yellow
        case .medium:
            return .orange
        case .high:
            return .red
        case .extreme:
            return .red
        }
    }
    
}

extension Double {
    /// Returns the risk level for the current number, interpreted using the specified covid statistics type.
    func riskLevel(for type: CovidStatisticType) -> RiskLevel {
        switch type {
        case .avarageCases:
            switch self {
            case 0:
                return .safe
            case 0...50:
                return .low
            case 50...1000:
                return .medium
            case 1000...2000:
                return .high
            default:
                return .extreme
            }
        case .averageDeaths:
            switch self {
            case 0:
                return .safe
            case 0...5:
                return .low
            case 5...10:
                return .medium
            case 10...100:
                return .high
            default:
                return .extreme
            }
        }
    }
}
