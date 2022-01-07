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
        
        // Generate a timeline consisting of 2 entries a minute apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 2 {
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
struct CovidTrackerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let location = entry.configuration.location, let county = County(named: location) {
            CountyView(county: county, statisticType: StatisticType(intentStatisticRawValue: entry.configuration.statistics.rawValue))
                .overlay(alignment: .topTrailing) {
                    HStack {
                        Spacer()
                        Text(entry.date, style: .relative)
                    }
                }
        } else {
            CountyView(county: County(testName: "Los Angeles Test"), statisticType: StatisticType(intentStatisticRawValue: entry.configuration.statistics.rawValue))
                .overlay(alignment: .topTrailing) {
                    HStack {
                        Spacer()
                        Text(entry.date, style: .relative)
                    }
                }
        }
        
        
        
    }
}

@main
struct CovidTrackerWidget: Widget {
    let kind: String = "CovidTrackerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CovidTrackerConfigurationIntent.self, provider: Provider()) { entry in
            CovidTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .onBackgroundURLSessionEvents { identifier in
            print("background URL Event \(identifier)")
            return true
        } _: { identifier, completion in
            completion()
        }

    }
}

struct CovidTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        CovidTrackerWidgetEntryView(entry: CovidTimelineEntry(date: Date(), configuration: CovidTrackerConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
