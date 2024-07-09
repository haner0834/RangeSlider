//
//  Direction.swift
//  
//
//  Created by Andy Lin on 2024/6/23.
//

import Foundation

public enum Direction {
    case right, left
    
    internal var isLeft: Bool { self == .left }
}
