//
//  Day.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/4/22.
//

import Foundation
import TabularData

/// A day's covid data for a county.
struct Day {
    var date: Date
    var county: String
    var state: String
    var cases: Double
    var averageCase: Double
    var deaths: Double
    var averageDeath: Double
    
    /// Creates a ``Day`` of data from a data frame row.
    init(fromDataFrameRow row: DataFrame.Row) {
        self.date = row[dateID]!
        self.county = row[countyID]!
        self.state = row[stateID]!
        self.cases = Double(row[casesID]!)
        self.averageCase = row[casesAverageID]!
        self.deaths = Double(row[deathsID]!)
        self.averageDeath = row[deathsAverageID]!
    }
    
    /// Creates a test-only ``Day``.
    init(testDate: Date, county: String, state: String, casesRandomizedAround casesBase: Double = 30000, deathsRandomizedAround deathsBase: Double = 100) {
        self.date = testDate
        self.county = county
        self.state = state
        self.cases = Double.random(in: casesBase...(1.2 * casesBase))
        self.averageCase = Double.random(in: (0.8 * casesBase)...casesBase)
        self.deaths = Double.random(in: 0...deathsBase)
        self.averageDeath = Double.random(in: 0...(0.5 * deathsBase))
    }
    
    
    func average(for type: CovidStatisticType) -> Double {
        switch type {
        case .avarageCases:
            return averageCase
        case .averageDeaths:
            return averageDeath
        }
    }
    
    
}
