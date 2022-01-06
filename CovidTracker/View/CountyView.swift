//
//  CountyView.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import SwiftUI
import WidgetKit

struct CountyView: View {
    var county: County
    var statisticType: StatisticType
    
    init(county: County, statisticType: StatisticType) {
        self.county = county
        self.statisticType = statisticType
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(BackgroundStyle())
            
            VStack {
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(county.name)
                                .font(.headline.bold())
                            Text(statisticType.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                    }
                    
                    LinePlot(values: county.days.map { $0.average(for: statisticType) }, color: county.risk(for: statisticType).color)
                }
                
                
                Spacer(minLength: 0)
                
                StatisticView(number: county.currentAverage(for: statisticType), change: county.currentChange(for: statisticType) ?? 0, risk: county.risk(for: statisticType))
            }
            
            .padding()
            
        }
    }
}

extension County {
    static let sampleCounty = County(testName: "Los Angeles")
    static let cupertino = County(named: "Santa Clara")
}

struct SeverityBackground: View {
    var riskLevel: RiskLevel

    var body: some View {
        Group {
            switch riskLevel {
            case .safe, .low, .medium, .high:
                Rectangle().fill(riskLevel.color)
            case .extreme:
                Rectangle().fill(BackgroundStyle())
            }
        }
    }
}


struct CountyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountyView(county: .sampleCounty, statisticType: .avarageCases)
            
            CountyView(county: .sampleCounty, statisticType: .avarageCases)
                .environment(\.locale, Locale(identifier: "zh-Hans"))
            CountyView(county: .sampleCounty, statisticType: .averageDeaths)
                .environment(\.colorScheme, .dark)
        }
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
