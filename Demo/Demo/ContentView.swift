//
//  ContentView.swift
//  Demo
//
//  Created by Andy Lin on 2024/7/9.
//

import SwiftUI
import RangeSlider

struct ContentView: View {
    // For bind: `ClosedRange<Double>`
    @State private var selection: ClosedRange<Double> = 20...50
    
    // For bind two `Double` value into a `RangeSlider`
    @State private var lowerBound = 20.0
    @State private var upperBound = 50.0
    
    var body: some View {
        VStack {
            //MARK: - Bind two values
            /// You can bind two `Double` value to a `RangeSlider` initializer as easy as this:
            Title("Bind two values")
            RangeSlider(upperBound: $upperBound, lowerBound: $lowerBound)
            
            //MARK: - Default UI settings
            Title("Default")
            RangeSlider(selection: $selection)
            
            /// Change value with step
            Title("Change With Step")
            RangeSlider(selection: $selection, step: 5)
            
            /// Prints "Hello world" whenever start the drag,
            /// Using initializer:
            Title("OnDraging(useing initializer)")
            RangeSlider(selection: $selection) {
                print("Hello world")
            }
            /// Or you can do it like this:
            Title("OnDraging(using modifier)")
            RangeSlider(selection: $selection)
                .onDragging {
                    print("Hello world")
                }
            
            /// Prints "Hello world whenever end the drag
            Title("On End")
            RangeSlider(selection: $selection)
                .onEnded {
                    print("Hello world")
                }
            
            /// Prints "Drag starts!" whenever start the drag,
            /// Or prints "Drag ends!" whenever end the drag.
            Title("On State Change")
            RangeSlider(selection: $selection)
                .onEditingChange { start in
                    /// A `Bool` value in closure,
                    /// to distinguish hether state is start or end.
                    if start {
                        print("Drag starts!")
                    }else {
                        print("Drag ends!")
                    }
                }
            
            //MARK: - Custom UI
            /// Use modifiers
            Title("Customize UI Use Modifiers")
            RangeSlider(selection: $selection)
                .thumb(scale: 20, // scale of the thumb
                       color: .black, // color of the thumb
                       isShowShadown: false) // whether to show shadown of thumb
                /// Change track color
                .track(.yellow) // color of middle track
                /// - Note: `tint(middle: )` and `tint(_:)` can do the same thing.
                .tint(left: .red, right: .green)
            
            /// Adds overlay to thumb
            Title("Overlay For Thumb")
            RangeSlider(selection: $selection) { direction in
                /// Given a `Direction` to distinguish thumb is left or right.
                if direction == .right {
                    // Right thumb overlay
                    Text(String(format: "%.0f", selection.upperBound))
                }else {
                    Text(String(format: "%.0f", selection.lowerBound))
                }
            }
            .thumb(scale: 30)
            .font(.caption)
            
            /// Strokeline style
            Title("Strokeline Style")
            RangeSlider(selection: $selection)
                .thumbStyle(.strokeLine,
                            color: .green,
                            lineWidth: 7)
                .thumb(scale: 30, frontThumbColor: .cyan)
                .track(height: 7)
            
            /// Track larger than thumb
            Title("Track Larger than Thumb")
            RangeSlider(selection: $selection)
                .track(height: 30)
                .thumb(scale: 16)
        }
    }
}

fileprivate struct Title: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .bold()
    }
}

#Preview {
    ContentView()
}
