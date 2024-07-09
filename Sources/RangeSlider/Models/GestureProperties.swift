//
//  GestureProperties.swift
//  
//
//  Created by Andy Lin on 2024/5/9.
//

import Foundation

internal struct GestureProperties {
    var offset: CGFloat = 0
    var lastStoreOffset: CGFloat = 0
    
    mutating func storeOffset() {
        lastStoreOffset = offset
    }
}
