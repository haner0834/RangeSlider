//
//  ClosedRangeExtension.swift
//  
//
//  Created by Andy Lin on 2024/6/23.
//

import Foundation

extension ClosedRange {
    init(lowerBound: Bound, upperBound: Bound) {
        let upper = upperBound < lowerBound ? lowerBound: upperBound
        let lower = lowerBound
        
        self.init(uncheckedBounds: (lower, upper))
    }
}
