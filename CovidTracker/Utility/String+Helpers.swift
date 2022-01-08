//
//  String+Helpers.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/6/22.
//

import Foundation

extension String {
    /// Returns the county name from the combined location name.
    var countyName: String {
        if let lastCommaIndex = self.lastIndex(of: ",") {
            return String(self[..<lastCommaIndex])
        } else {
            return self
        }
    }
}
