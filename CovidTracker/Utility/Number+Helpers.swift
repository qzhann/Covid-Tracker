//
//  Number+Helpers.swift
//  CovidTracker
//
//  Created by Zihan Qi on 1/5/22.
//

import Foundation

extension FloatingPoint {
    /// Normalize a value by interpolating it in the given range.
    ///
    /// If the current value is equal to lower bound, the normalized value will be 0. If the current value is equal to the upper bound, the normalized value will be 1.
    /// All other values will be interpolated using this rule.
    func normalized(in range: ClosedRange<Self>) -> Self {
        let rangeSize = range.upperBound - range.lowerBound
        let interpolatedValue = (self - range.lowerBound) / rangeSize
        return interpolatedValue
    }
}
