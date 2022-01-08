//
//  CountyStatisticView.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/6/22.
//

import SwiftUI
import WidgetKit

struct CountyStatisticView: View {
    
    var county: County
    var statisticType: CovidStatisticType
    @Environment(\.widgetFamily) var family

    init(county: County, statisticType: CovidStatisticType) {
        self.county = county
        self.statisticType = statisticType
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(BackgroundStyle())
            
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(county.name)
                            .font(.headline.bold())
                        if family != .systemSmall {
                            Text(county.stateName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                        }
                    }
                    Spacer()
                }
                
                
                Spacer(minLength: 0)
                
                switch family {
                case .systemSmall:
                    SmallCountyStatisticView(county: county, statisticType: statisticType)
                    
                default:
                    MediumCountyStatisticView(county: county, statisticType: statisticType)
                    Spacer()
                    
                }
            }
            .padding()

        }
    }
}

struct SmallCountyStatisticView: View {
    var county: County
    var statisticType: CovidStatisticType

    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Average")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    NumberView(number: county.currentAverage(for: statisticType), change: county.currentChange(for: .avarageCases) ?? 0, risk: county.risk(for: statisticType))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("New Today")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    NumberView(number: county.newToday(for: statisticType), risk: county.risk(for: statisticType))
                }
            }
            
            Spacer()
        }
    }
}

struct MediumCountyStatisticView: View {
    var county: County
    var statisticType: CovidStatisticType
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Average")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                NumberView(number: county.currentAverage(for: statisticType), change: county.currentChange(for: .avarageCases) ?? 0, risk: county.risk(for: statisticType))
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("New Today")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                NumberView(number: county.newToday(for: statisticType), risk: county.risk(for: statisticType))
            }
        }
        .padding(.trailing)
    }
}

struct CountyStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        SmallCountyStatisticView(county: .sampleCounty, statisticType: .avarageCases)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        SmallCountyStatisticView(county: .sampleCounty, statisticType: .avarageCases)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.locale, Locale(identifier: "zh-Hans"))
        

        CountyStatisticView(county: .sampleCounty, statisticType: .avarageCases)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environment(\.colorScheme, .dark)


    }
}
