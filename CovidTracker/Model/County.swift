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
        
    /// Creates a ``County`` using the location name. If the county is not found, or does not have any data, this initializer returns nil.
    init?(named locationName: String) {
        guard let countyRecents = CentralDataStore.shared.recents(for: locationName) else { return nil }
        self.name = locationName.countyName
        self.days = countyRecents.reversed()
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
    
    func currentAverage(for type: CovidStatisticType) -> Double {
        switch type {
        case .avarageCases:
            return latestDay.averageCase
        case .averageDeaths:
            return latestDay.averageDeath
        }
    }
    
    func newToday(for type: CovidStatisticType) -> Double {
        switch type {
        case .avarageCases:
            return latestDay.cases
        case .averageDeaths:
            return latestDay.averageDeath
        }
    }
    
    func currentChange(for type: CovidStatisticType) -> Double? {
        guard let latestDay = self.dayFromMostRecentDay(0), let dayBefore = self.dayFromMostRecentDay(1) else { return nil }

        switch type {
        case .avarageCases:
            return latestDay.averageCase - dayBefore.averageCase
        case .averageDeaths:
            return latestDay.averageDeath - dayBefore.averageDeath
        }
    }
    
    func risk(for type: CovidStatisticType) -> RiskLevel {
        switch type {
        case .avarageCases:
            return latestDay.averageCase.riskLevel(for: .avarageCases)
        case .averageDeaths:
            return latestDay.averageDeath.riskLevel(for: .averageDeaths)
        }
    }
    
    func rawData(for type: CovidStatisticType) -> [Double] {
        return days.map { $0.average(for: type)}.reversed()
    }
    
    
}
