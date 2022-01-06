//
//  CentralDataStore.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/4/22.
//

import Foundation
import TabularData

// column ID to parse csv from web
let dateID = ColumnID("date", Date.self)
let countyID = ColumnID("county", String.self)
let stateID = ColumnID("state", String.self)
let casesID = ColumnID("cases", Int.self)
let casesAverageID = ColumnID("cases_avg", Double.self)
let deathsID = ColumnID("deaths", Int.self)
let deathsAverageID = ColumnID("deaths_avg", Double.self)

/// Stores the CSV data parsed from the web. This class is usful for storing and managing all csv data from web.
class CentralDataStore {
    
    var datas: DataFrame!
    
    init() {
        self.datas = covidDataFromGithub()
    }
    
    /// Returns a freshly pulled covid data from Github.
    func covidDataFromGithub() -> DataFrame {
        let url = URL(string: "https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-recent.csv")!
        
        // csv reading options
        var readingOptions = CSVReadingOptions(hasHeaderRow: true, nilEncodings: [""], ignoresEmptyLines: true, delimiter: ",")
        // adding date parsing strategy
        readingOptions.addDateParseStrategy(
            Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)",
                               locale: Locale(identifier: "en_US"),
                               timeZone: TimeZone(abbreviation: "PST")!)
        )
        
        let allCSVData = try! DataFrame(
            contentsOfCSVFile: url,
            columns: [dateID.name, countyID.name, stateID.name, casesID.name, casesAverageID.name, deathsID.name, deathsAverageID.name],
            rows: nil,
            types: [dateID.name: .date, countyID.name: .string, stateID.name: .string, casesID.name: .integer, casesAverageID.name: .double, deathsID.name: .integer, deathsAverageID.name: .double],
            options: readingOptions)
        
        return allCSVData
    }
    
    /// Refresh the data by repulling from Github.
    func refreshData() {
        self.datas = covidDataFromGithub()
    }
    
    /// Returns the recent day datas for the specified county. If the county cannot be found, or there are no data for the county, this method returns nil.
    func recents(for county: String) -> [Day]? {
        let countyRecentData = datas.recents(county: county).rows.map { Day(fromDataFrameRow: $0) }
        if countyRecentData.isEmpty {
            return nil
        } else {
            return countyRecentData
        }
        
    }
    
    static var shared = CentralDataStore()
}


extension DataFrame {
    
    /// Returns a ``DataFrame`` in which the date is reverse sorted.
    func chronologicallyReversed() -> DataFrame {
        return self.sorted(on: dateID, order: .descending)
    }
    
    /// Returns the rows containing only the data for the specified county, starting from the most recent data.
    func recents(county: String) -> DataFrame.Slice {
        return self.filter(on: countyID, { $0 == county })
    }
}
