//
//  IntentHandler.swift
//  CovidTrackerIntentHandler
//
//  Created by Zihan Qi on 1/6/22.
//

import Intents

class IntentHandler: INExtension, CovidTrackerConfigurationIntentHandling {
    func provideLocationOptionsCollection(for intent: CovidTrackerConfigurationIntent) async throws -> INObjectCollection<NSString> {
        return INObjectCollection(items: allUSCountyNames.map { $0 as NSString })
    }
    
    func defaultLocation(for intent: CovidTrackerConfigurationIntent) -> String? {
        return "Los Angeles, California"
    }
}
