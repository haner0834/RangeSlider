//
//  Thumb.swift
//  
//
//  Created by Andy Lin on 2024/5/9.
//

import Foundation
import SwiftUI

internal struct Thumb<ThumbOverlay: View> {
    var color: Color
    var scale: CGFloat
    var isShow: Bool
    var isShowShadown: Bool
    var style: ThumbStyle
    var strokeLineWidth: CGFloat?
    var frontThumbColor: Color
    @ViewBuilder var overlay: (Direction) -> ThumbOverlay
    
    init(color: Color,
         scale: CGFloat,
         isShow: Bool = true,
         isShowShadown: Bool = true,
         style: ThumbStyle = .fill,
         frontThumbColor: Color = .white,
         strokeLineWidth: CGFloat? = nil,
         @ViewBuilder overlay: @escaping (Direction) -> ThumbOverlay) {
        self.color = color
        self.scale = scale
        self.isShow = isShow
        self.isShowShadown = isShowShadown
        self.style = style
        self.strokeLineWidth = strokeLineWidth
        self.frontThumbColor = frontThumbColor
        self.overlay = overlay
    }
}

/// The style for thumb.
public enum ThumbStyle {
    /// Fill color style.
    case fill
    /// Border fill color style.
    case strokeLine
}
