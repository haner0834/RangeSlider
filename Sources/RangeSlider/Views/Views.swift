//
//  Views.swift
//  
//
//  Created by Andy Lin on 2024/5/5.
//

import SwiftUI

internal extension RangeSlider {
    @ViewBuilder
    func ThumbView(offset: CGFloat,
                   size: CGSize,
                   for side: Direction,
                   onChange: @escaping (DragGesture.Value) -> Void,
                   onEnded: @escaping () -> Void) -> some View {
        let thumbWidth = thumb.scale
        let trackHeight = track.height
        Circle()
            .trim(from: 0.0, to: thumbWidth < trackHeight ? 0.5: 1)
            .rotation(.degrees(side.isLeft ? 90: -90))
            .frame(width: maxThumbScale, height: maxThumbScale)
            .customForegroundStyle(thumbWidth < trackHeight ? track.middle :thumb.color)
            .shadow(color: !thumb.isShowShadown || thumbWidth < trackHeight ? .clear: .black.opacity(0.3), radius: 5)
            .offset(x: offset)
            .customOverlay {
                if thumb.style == .strokeLine || thumbWidth < trackHeight {
                    let lineWidth = thumb.strokeLineWidth ?? maxThumbScale * 0.16
                    let circleWidth = (thumb.style == .strokeLine) ? maxThumbScale - (2 * lineWidth): thumbWidth
                    let color = thumb.style != .strokeLine || thumbWidth < trackHeight ? thumb.color: thumb.frontThumbColor
                    Circle()
                        .frame(width: circleWidth, height: thumbWidth)
                        .customForegroundStyle(color)
                        .offset(x: offset)
                        .shadow(color: thumb.isShowShadown && thumbWidth < trackHeight ? .black.opacity(0.3): .clear, radius: 5)
                }
            }
            .customOverlay {
                self.thumb.overlay(side)
                    .frame(width: thumbWidth, height: thumbWidth)
                    .offset(x: offset)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { newValue in
                        onChange(newValue)
                    }
                    .onEnded { _ in
                        onEnded()
                    }
            )
    }
}


#Preview {
    RangeSlider(selection: .constant(10...70))
        .thumb(scale: 30)
        .thumbStyle(.strokeLine, color: .blue)
}
