//
//  CountyTrendView.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import SwiftUI
import WidgetKit

struct CountyTrendView: View {
    var county: County
    var statisticType: CovidStatisticType
    
    init(county: County, statisticType: CovidStatisticType) {
        self.county = county
        self.statisticType = statisticType
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(BackgroundStyle())
            
            VStack {
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(county.name)
                                .font(.headline.bold())
                                .lineSpacing(-10)
                                .lineLimit(nil)
                            Text(statisticType.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        
                        Spacer()
                    }

                    LinePlot(values: county.rawData(for: statisticType), color: county.risk(for: statisticType).color)
                    
                }
                
                
                Spacer(minLength: 0)
                
                HStack {
                    Spacer()

                    NumberView(number: county.currentAverage(for: statisticType), change: county.currentChange(for: statisticType) ?? 0, risk: county.risk(for: statisticType))
                        .layoutPriority(1)
                    
                }
            }
            
            .padding()
            
        }
    }
}

extension County {
    static let sampleCounty = County(testName: "San Bernadino")
    static let cupertino = County(named: "Los Angeles")
}


struct CountyTrendView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountyTrendView(county: .sampleCounty, statisticType: .avarageCases)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            CountyTrendView(county: .sampleCounty, statisticType: .averageDeaths)
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            CountyTrendView(county: .sampleCounty, statisticType: .avarageCases)
                .environment(\.colorScheme, .dark)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            CountyTrendView(county: .sampleCounty, statisticType: .averageDeaths)
                .environment(\.colorScheme, .dark)
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))


        }
//        .environment(\.dynamicTypeSize, .accessibility5)
        
    }
}
