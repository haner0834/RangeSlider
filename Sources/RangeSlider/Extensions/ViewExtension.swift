//
//  ViewExtension.swift
//  
//
//  Created by Andy Lin on 2024/6/17.
//

import SwiftUI
extension View {
    //For supporting foregroundStyle API to iOS 14 or lower.
    @ViewBuilder
    func customForegroundStyle(_ color: Color) -> some View {
        ///Because `foregroundStyle(_:)` only support iOS 15 or newer.
        if #unavailable(iOS 17, macOS 12) {
            self.foregroundColor(color)
        }else {
            self.foregroundStyle(color)
        }
    }
    
    #if os(iOS) || os(watchOS) || os(tvOS)
    //For supporting .rect style to iOS 16 or lower.
    @ViewBuilder
    func customCornerRadius(in corners: UIRectCorner, radius: CGFloat) -> some View {
        ///Because `.rect` style only support iOS 17 or newer
        clipShape(RoundedCorner(corners: corners, radius: radius))
    }
    #elseif os(macOS)
    @ViewBuilder
    func customCornerRadius(in corners: RectCorner, radius: CGFloat) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    #endif
    
    //For supporting overlay API to iOS 14 or lower
    @ViewBuilder
    func customOverlay<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(OverlayModifier(alignment: alignment, overlay: content))
    }
}
