//
//  Inits.swift
//  
//
//  Created by Andy Lin on 2024/5/5.
//

import SwiftUI

//MARK: Inits
public extension RangeSlider where ThumbOverlay == EmptyView {
    
    /// Create a range slider to select values from a given range.
    /// - Parameters:
    ///   - selection: The value to binding.
    ///   - range: The range of valid value. Defaults to `0...100`.
    ///   - step: The step of value changing. Default is `nil`.
    ///   - onDraging: The action to perform while the thumb is dragged.
    ///
    /// The slider calls `onDragging` to perform when editing being.
    /// For example, when user drag one of two thumbs, the `onDragging` will be perform.
    ///
    /// ```swift
    /// RangeSlider(selection: $value) {
    ///     print("Hello world! :D")
    /// }
    /// ```
    init(selection: Binding<ClosedRange<Double>>,
         in range: ClosedRange<CGFloat> = 0...100,
         step: CGFloat? = nil,
         onDraging perform: @escaping () -> Void) {
        self.init(selection: selection, step: step, range: range, onEditingChangePerform: {
            if $0 { perform() }
        }, thumbOverlay: { _ in })
    }
    
    /// Create a slider to select values from a given range.
    /// Be used to binding two values to one slider.
    /// - Parameters:
    ///   - lowerBound: Lower bound to bind into slider.
    ///   - upperBound: Upper bound to bind into slider.
    ///   - range: The range of valid value. Defaults to `0...100`.
    ///   - step: The step of value changing. Default is nil.
    ///
    /// While using this initializer, please check the `upperBound` value, do not let it less than `loweerBound`.
    /// Though there's value-safety checking to pervent `lowerBound` larger than `upperBound`,
    /// having `upperBound` less than `lowerBound` can be performed but not suppored.
    init(upperBound: Binding<Double>,
         lowerBound: Binding<Double>,
         in range: ClosedRange<CGFloat> = 0...100,
         step: CGFloat? = nil) {
        ///Turning two `Double` value to one `ClosedRange<Double>`
        
        self.init(selection:
                    Binding(
                        get: { ClosedRange(lowerBound: lowerBound.wrappedValue, upperBound: upperBound.wrappedValue) },
                        set: { newValue in
                            upperBound.wrappedValue = newValue.upperBound
                            lowerBound.wrappedValue = newValue.lowerBound
                        }
                    ),
                  step: step,
                  range: range,
                  thumbOverlay: { _ in }
        )
    }
    
    /// Create a range slider to select values from a given range.
    /// - Parameters:
    ///   - selection: The value to binding.
    ///   - step: Determines the step of value changing. Default is `nil`.
    ///   - range: The range of valid value. Defaults to `0...100`.
    init(selection: Binding<ClosedRange<Double>>,
         in range: ClosedRange<CGFloat> = 0...100,
         step: CGFloat? = nil) {
        self.init(selection: selection, step: step, range: range, thumbOverlay: { _ in })
    }
}

public extension RangeSlider {
    /// Create a range slider to select values from a given range.
    /// - Parameters:
    ///   - selection: Selected value within bounds.
    ///   - range: The range of valid value. Defauls is `0...100`
    ///   - step: Determines the step of value changing. Default is `nil`.
    ///   - thumbOverlay: The thumb's oevrlay.
    ///
    /// It allows adding different view to left and right thumb,
    /// to distinguish two thumb, use given parameter direction to customize different views.
    ///
    /// The following example shows how to add different views to left and right thumb:
    ///
    /// ```swift
    /// @State private var selection: ClosedRange<Double> = 20...50
    ///
    /// var body: some View {
    ///     RangeSlider(selection: $selection) { direction in
    ///         if direction == .left {
    ///             // views for left thumb
    ///             Text(String(format: "%.0f", selection.lowerBound))
    ///         }else {
    ///             // views for right thumb
    ///             Text(String(format: "%.0f", selection.upperBound))
    ///         }
    ///     }
    ///     .thumb(scale: 30)
    ///     .font(.caption2)
    /// }
    /// ```
    ///
    /// Result:
    /// ![withoverlay](https://scontent.xx.fbcdn.net/v/t1.15752-9/449073048_1001338121581026_1576437319079074797_n.png?_nc_cat=107&ccb=1-7&_nc_sid=0024fc&_nc_ohc=ErWwbsuZs8cQ7kNvgFFbAw5&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_Q7cD1QHcRZSG0y0dqidwEIvixjNOJ_mO2REdFuHn9jiO3JvTiQ&oe=66B227D4)
    init(selection: Binding<ClosedRange<Double>>,
         in range: ClosedRange<CGFloat> = 0...100,
         step: CGFloat? = nil,
         @ViewBuilder thumbOverlay: @escaping (Direction) -> ThumbOverlay) {
        self.init(selection: selection, step: step, range: range, thumbOverlay: thumbOverlay)
    }
    
    /// Create a range slider to select values from a given range.
    /// - Parameters:
    ///   - lowerBound: Lower bound to bind into slider.
    ///   - upperBound: Upper bound to bind into slider.
    ///   - range: The range of valid value. Defauls is `0...100`
    ///   - step: Determines the step of value changing. Default is `nil`.
    ///   - thumbOverlay: The thumb's oevrlay.
    ///
    ///
    /// It allows adding different view to left and right thumb,
    /// to distinguish two thumb, use given parameter direction to customize different views.
    ///
    /// The following example shows how to add different views to left and right thumb:
    ///
    /// ```swift
    /// @State private var selection: ClosedRange<Double> = 20...50
    ///
    /// var body: some View {
    ///     RangeSlider(selection: $selection) { direction in
    ///         if direction == .left {
    ///             // views for left thumb
    ///             Text(String(format: "%.0f", selection.lowerBound))
    ///         }else {
    ///             // views for right thumb
    ///             Text(String(format: "%.0f", selection.upperBound))
    ///         }
    ///     }
    ///     .thumb(scale: 30)
    ///     .font(.caption2)
    /// }
    /// ```
    ///
    /// Result:
    /// ![withoverlay](https://scontent.xx.fbcdn.net/v/t1.15752-9/449073048_1001338121581026_1576437319079074797_n.png?_nc_cat=107&ccb=1-7&_nc_sid=0024fc&_nc_ohc=ErWwbsuZs8cQ7kNvgFFbAw5&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.xx&oh=03_Q7cD1QHcRZSG0y0dqidwEIvixjNOJ_mO2REdFuHn9jiO3JvTiQ&oe=66B227D4)
    init(lowerBound: Binding<Double>,
         upperBound: Binding<Double>,
         in range: ClosedRange<CGFloat> = 0...100,
         step: CGFloat? = nil,
         @ViewBuilder thumbOverlay: @escaping (Direction) -> ThumbOverlay) {
        
        self.init(selection:
                    Binding(
                        get: { ClosedRange(lowerBound: lowerBound.wrappedValue, upperBound: upperBound.wrappedValue) },
                        set: { newValue in
                            upperBound.wrappedValue = newValue.upperBound
                            lowerBound.wrappedValue = newValue.lowerBound
                        }
                    ),
                  step: step,
                  range: range,
                  thumbOverlay: thumbOverlay)
    }
}
