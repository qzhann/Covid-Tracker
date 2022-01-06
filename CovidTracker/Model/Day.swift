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
    var averageCases: Double
    var deaths: Double
    var averageDeaths: Double
    
    /// Creates a ``Day`` of data from a data frame row.
    init(fromDataFrameRow row: DataFrame.Row) {
        self.date = row[dateID]!
        self.county = row[countyID]!
        self.state = row[stateID]!
        self.cases = Double(row[casesID]!)
        self.averageCases = row[casesAverageID]!
        self.deaths = Double(row[deathsID]!)
        self.averageDeaths = row[deathsAverageID]!
    }
    
    /// Creates a test-only ``Day``.
    init(testDate: Date, county: String, state: String, casesRandomizedAround casesBase: Double = 30000, deathsRandomizedAround deathsBase: Double = 100) {
        self.date = testDate
        self.county = county
        self.state = state
        self.cases = Double.random(in: casesBase...(1.2 * casesBase))
        self.averageCases = Double.random(in: (0.8 * casesBase)...casesBase)
        self.deaths = Double.random(in: 0...deathsBase)
        self.averageDeaths = Double.random(in: 0...(0.5 * deathsBase))
    }
    
    
    func average(for type: StatisticType) -> Double {
        switch type {
        case .avarageCases:
            return averageCases
        case .averageDeaths:
            return averageDeaths
        }
    }
    
    
}
