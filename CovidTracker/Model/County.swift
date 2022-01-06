//
//  County.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import Foundation

struct County {
    
    var name: String
    var stateName: String
    
    /// The days data for the current ``County``, sorted in reverse chronological order.
    var days: [Day]
    
    /// Creates a ``County`` using the name. If the county is not found, or does not have any data, this initializer returns nil.
    init?(named countyName: String) {
        guard let countyRecents = CentralDataStore.shared.recents(for: countyName) else { return nil }
        self.name = countyName
        self.days = countyRecents
        self.stateName = countyRecents.first!.state
    }
    
    /// Creates a test-only ``County`` using the county name.
    init(testName: String) {
        let countyName = testName
        let stateName = "California"
        self.name = countyName
        self.stateName = stateName
        
        let testWeek: [Day] = {
            let today = Calendar.current.startOfDay(for: Date())
            let pastWeek = (0...6).map { Day(testDate: Calendar.current.date(byAdding: .day, value: -$0, to: today)!, county: countyName, state: stateName) }
            return pastWeek
        }()
        self.days = testWeek
    }
    
    private func dayFromMostRecentDay(_ offset: Int) -> Day? {
        guard offset >= 0 && offset < days.count else { return nil }
        return days[offset]
    }
    
    var latestDay: Day {
        dayFromMostRecentDay(0)!
    }
    
    func currentAverage(for type: StatisticType) -> Double {
        switch type {
        case .avarageCases:
            return latestDay.averageCases
        case .averageDeaths:
            return latestDay.averageDeaths
        }
    }
    
    func currentChange(for type: StatisticType) -> Double? {
        guard let latestDay = self.dayFromMostRecentDay(0), let dayBefore = self.dayFromMostRecentDay(1) else { return nil }

        switch type {
        case .avarageCases:
            return latestDay.averageCases - dayBefore.averageCases
        case .averageDeaths:
            return latestDay.averageDeaths - dayBefore.averageDeaths
        }
    }
    
    func risk(for type: StatisticType) -> RiskLevel {
        switch type {
        case .avarageCases:
            return latestDay.averageCases.riskLevel(for: .avarageCases)
        case .averageDeaths:
            return latestDay.averageDeaths.riskLevel(for: .averageDeaths)
        }
    }
    
    
}
