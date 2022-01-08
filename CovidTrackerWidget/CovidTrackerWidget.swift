//
//  CovidTrackerWidget.swift
//  CovidTrackerWidget
//
//  Created by Zihan Qi on 1/5/22.
//

import WidgetKit
import SwiftUI
import Intents

/// Timeline Provider provides the data source to update our widget.
struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> CovidTimelineEntry {
        let intent = CovidTrackerConfigurationIntent()
        intent.location = "Los Angeles, California"
        intent.statistics = .cases
        return CovidTimelineEntry(date: Date(), configuration: intent)
    }

    func getSnapshot(for configuration: CovidTrackerConfigurationIntent, in context: Context, completion: @escaping (CovidTimelineEntry) -> ()) {
        let entry = CovidTimelineEntry(date: Date(),  configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: CovidTrackerConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
                
        var entries: [CovidTimelineEntry] = []
        
        // Generate a 30-min timeline consisting entries 5 minutes apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in stride(from: 0, to: 30, by: 5) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = CovidTimelineEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CovidTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: CovidTrackerConfigurationIntent
}


/// A view that's rendered based on the timeline data source, a timeline entry.
struct CovidTrackerWidgetTrendView : View {
    var entry: Provider.Entry

    var body: some View {
        Group {
            if let location = entry.configuration.location, let county = County(named: location) {
                CountyTrendView(county: county, statisticType: CovidStatisticType(intentStatisticRawValue: entry.configuration.statistics.rawValue))
            } else {
                CountyTrendView(county: County(testName: "Los Angeles"), statisticType: CovidStatisticType(intentStatisticRawValue: entry.configuration.statistics.rawValue))
            }
        }
//        .overlay(alignment: .topTrailing) {
//            HStack {
//                Spacer()
//                Text(entry.date, style: .relative).font(.system(.footnote, design: .monospaced))
//            }
//        }
    }
}

struct CovidTrackerWidgetStatisticView: View {
    var entry: Provider.Entry

    var body: some View {
        Group {
            if let location = entry.configuration.location, let county = County(named: location) {
                CountyStatisticView(county: county, statisticType: CovidStatisticType(intentStatisticRawValue: entry.configuration.statistics.rawValue))
            } else {
                CountyStatisticView(county: County(testName: "Los Angeles"), statisticType: CovidStatisticType(intentStatisticRawValue: entry.configuration.statistics.rawValue))
            }
        }
//        .overlay(alignment: .topTrailing) {
//            HStack {
//                Spacer()
//                Text(entry.date, style: .relative).font(.system(.footnote, design: .monospaced))
//            }
//        }
    }
}

struct CovidTrackerTrendWidget: Widget {
    let kind: String = "Trend"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CovidTrackerConfigurationIntent.self, provider: Provider()) { entry in
            CovidTrackerWidgetTrendView(entry: entry)
        }
        .configurationDisplayName("Trend")
        .description("Track the trend of COVID-19 in your county.")
    }
}

struct CovidTrackerStatisticWidget: Widget {
    let kind: String = "Statistics"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CovidTrackerConfigurationIntent.self, provider: Provider()) { entry in
            CovidTrackerWidgetStatisticView(entry: entry)
        }
        .configurationDisplayName("Statistics")
        .description("Track the trend of COVID-19 in your county.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct CovidTrackerWidgets: WidgetBundle {
    var body: some Widget {
        CovidTrackerTrendWidget()
        CovidTrackerStatisticWidget()
    }
    
}

struct CovidTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        CovidTrackerWidgetTrendView(entry: CovidTimelineEntry(date: Date(), configuration: CovidTrackerConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        CovidTrackerWidgetStatisticView(entry: CovidTimelineEntry(date: Date(), configuration: CovidTrackerConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

    }
}
