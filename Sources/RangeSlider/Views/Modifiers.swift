//
//  ViewModifier.swift
//  
//
//  Created by Andy Lin on 2024/5/5.
//

import Foundation
import SwiftUI

public extension RangeSlider {
    
    /// Setes the slider track color.
    /// - Parameter color: The color for the middle slider track.
    /// - Returns: A `RangeSlider` view with input setting.
    ///
    /// The following sample shows a view which is setted a middle track  color.
    ///
    /// ```swift
    /// @State private var value: ClosedRange<Double> = 20...50
    ///
    /// var body: some View {
    ///     RangeSlider(selection: $value)
    ///         .tint(.red)
    /// }
    /// ```
    ///
    /// ![red track style](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/red.png?raw=true)
    func tint(_ color: Color) -> RangeSlider {
        var slider = self
        slider.track.middle = color
        return slider
    }
    
    /// Customize slider color.
    /// - Parameters:
    ///   - left: The color between minimum range to the first thumb.
    ///   - middle: The color to the middle of the track.
    ///   - right: The color between maxmimum range to the second thumb.
    ///   - background: The color under the slider track.
    /// - Returns: A `RangeSlider` view with input settings.
    ///
    /// You can use `left`, `middle`, `right` to modify how was the track looks.
    /// The following example shows a `Rangeslider` with custom color.
    ///
    /// ```swift
    /// RangeSlider(selection: $selection)
    ///     .tint(left: .red, middle: .accentColor.opacity(0.5), right: .green)
    /// ```
    ///
    /// ![red-blue-green track style](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/red-blue-green.png?raw=true)
    ///
    /// - Note: `left` and `right` are part of track, so it is above `background`.
    /// The color of `left` and `right` will cover `background` color if it's not `nil`.
    func tint(left: Color? = nil, middle: Color? = nil, right: Color? = nil, background: Color? = nil) -> RangeSlider {
        var slider = self
        
        if let background { slider.track.background = background }
        
        if let left { slider.track.left = left }
        
        if let middle { slider.track.middle = middle }
        
        if let right { slider.track.right = right }
        
        return slider
    }
    
    /// Customize thumb.
    /// - Parameters:
    ///   - width: A `CGFloat` value that determines thumb scale.
    ///   - color: A `Color` value that determines thumb color.
    ///   - frontThumbColor: A `Color` value that determines thumb color while the thumb style is `.strokeLine`.
    ///   - isShowShadown: A Boolean value that determines whether to show the shadown on thumb
    /// - Returns: A `RangeSlider` view with input settings.
    ///
    /// Notice `frontThumbColor`and `color`,
    /// the different is while thumb style is `.strokeLine`,
    /// the `frontThumbColor` is the smaller one on the thumb.
    ///
    /// Here is the example:
    ///
    /// ```swift
    /// RangeSlider(selection: $value)
    ///     .thumb(color: .green, frontThumbColor: .yellow)
    ///     .thumbStyle(.strokeLine)
    ///     .thumbShadownHidden()
    /// ```
    ///
    /// And this is how it looks:
    /// ![stroke style, yellow thumb](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/strokeline-green-yellow.png?raw=true)
    ///
    /// - Note: If thumb scale is less than track, the thumb color is determines by `color`, instead of `frontThumbColor`.
    func thumb(scale: CGFloat? = nil, color: Color? = nil, frontThumbColor: Color? = nil, isShowShadown: Bool? = nil) -> RangeSlider {
        var slider = self
        
        if let color { slider.thumb.color = color }
        
        if let frontThumbColor { slider.thumb.frontThumbColor = frontThumbColor }
        
        if let scale { slider.thumb.scale = scale }
        
        if let isShowShadown { slider.thumb.isShowShadown = isShowShadown }
        
        return slider
    }
    
    /// Sets visibility of slider track background.
    /// - Parameter visibility: A`Visibility` enum value that determines whether to show the slider background track.
    /// - Returns: A `RangeSlider` view with input setting.
    ///
    /// The following example shows a `RangeSlider` without background.
    ///
    /// - Note: `left` and `right` are not hidden when using this modifier,
    /// because `left`,  `right` and `middle` is part of track, but `background` is not.
    ///
    /// ```swift
    /// RangeSlider(selection: $value)
    ///     .trackBackgroundHidden()
    /// ```
    /// The result:
    /// ![no background](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/no-background.png?raw=true)
    func trackBackgroundHidden(_ visibility: ViewVisibility = .hidden) -> RangeSlider {
        var slider = self
        slider.track.isShowBackground = visibility.isVisible
        return slider
    }
    
    /// Adds an action to be performed when the slider is being dragged.
    /// - Parameter perform: The action to perform.
    /// - Returns: The `RangeSlider` view that triggers action during the drag.
    ///
    /// The action will be done while dragging the slider.
    /// The action will only be triggered when the slider thumb is on dragging,
    /// which means there will nothing todo when slider thumb state change to not on dragging.
    ///
    /// If you need to do something at the end of the drag, please use ``onEnded(_:)`` to handle the completion event.
    ///
    /// ```swift
    /// @State private var number = 0
    ///
    /// var body: some View {
    ///      VStack {
    ///         Text("Number: \(number)")
    ///
    ///         RangeSlider(selection: $value)
    ///             .onDragging {
    ///                 number += 1
    ///             }
    ///      }
    /// }
    /// ```
    func onDragging(_ perform: @escaping () -> Void) -> RangeSlider {
        var slider = self
//        slider.onDragingPerform = perform
        slider.onEditingChangePerform = { isGoingToDrag in
            if isGoingToDrag { perform() }
        }
        return slider
    }
    
    /// Adds an action to be performed when the drag is ended.
    /// - Parameter perform: The acton to perform.
    /// - Returns: The `RangeSlider` view that triggers action while drag is ended.
    ///
    /// The action will be triggered at the end of drag.
    ///
    /// If you need to do something at the start of drag, please use ``onDragging(_:)``,
    /// or you want to do something at the start and end of drag, use ``onEditingChange(_:)``.
    ///
    /// ```swift
    /// RangeSlider(selection: $value)
    ///     .onEnded {
    ///         print("The slider is not on drag.")
    ///         //prints "The slider is not on drag."
    ///     }
    /// ```
    func onEnded(_ perform: @escaping () -> Void) -> RangeSlider {
        var slider = self
//        slider.onEndedPerform = perform
        slider.onEditingChangePerform = { isGoingToDrag in
            if !isGoingToDrag { perform() }
        }
        return slider
    }
    
    /// Adds an action to be performed when the editing change.
    /// - Parameter perform: The action to perform
    /// - Returns: The `RangeSlider` view that triggers given action when editing change.
    ///
    /// If you need to do something only at the start of drag, please use ``onDragging(_:)``,
    /// or you want to do something only at the end of drag, lease use ``onEnded(_:)``.
    ///
    /// The following example shows a `RangeSlider` print it's value when editing change.
    ///
    /// ```swift
    /// @State private var selection: ClosedRange<Double> = 20...50
    /// var body: some View {
    ///     RangeSlider(selection: $selection)
    ///         .onEditingChange { editing in
    ///             print(editing ? "drag start, value: \(selection)":
    ///                     "drag end, value: \(selection)")
    ///         }
    /// }
    /// ```
    func onEditingChange(_ perform: @escaping (Bool) -> Void) -> RangeSlider {
        var slider = self
        slider.onEditingChangePerform = perform
        return slider
    }
    
    /// Modify the appearace of the slider track.
    /// - Parameters:
    ///   - color: The color of the track between two thumb.
    ///   - background: The background track color.
    ///   - height: The track height.
    /// - Returns: A `RangeSlider` view modified for track.
    ///
    /// While the `height` larger than it's thumb scale, the view will be like:
    ///
    /// ![track height larger than thumb scale](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/track-larger.png?raw=true)
    ///
    /// If you want to know how to customize it's style, go to ``thumb(scale:color:frontThumbColor:isShowShadown:)`` or ``tint(left:middle:right:background:)``.
    func track(_ color: Color? = nil, background: Color? = nil, height: CGFloat? = nil) -> RangeSlider {
        var slider = self
        if let color { slider.track.middle = color }
        if let height { slider.track.height = height }
        if let background { slider.track.background = background }
        return slider
    }
    
    /// Setes the visibility of thumb shadown.
    /// - Parameter shadown: A value that determines whether to show the shadown under thumb. Default is `.hidden`
    /// - Returns: A`RangeSlider` view that thumb has shadown while `shadown` is true.
    func thumbShadownHidden(_ shadown: ViewVisibility = .hidden) -> RangeSlider {
        var slider = self
        slider.thumb.isShowShadown = shadown.isVisible
        return slider
    }
    
    /// Modify thumb from different style.
    /// - Parameters:
    ///   - style: Determines what style to show.
    ///   - color: Sets the color of track and thumb while the style is `.strokeLine`. Default is `nil`.
    ///   - lineWidth: Determines the thickness of the stroke line. Default is `nil`
    /// - Returns: A `RangeSlider` view that be setted to custom style.
    ///
    /// Use this method to apply a custom style to the thumb of a `RangeSlider`.
    /// The `style` parameter allows you to choose from various predefined styles.
    /// If the `style` parameter is set to `.strokeLine`, 
    /// you can also specify a `color` and `lineWidth` to further customize the appearance.
    ///
    /// - Note: Attention to the `color` parameter,
    ///  while `stroke` is set to `.strokeLine`, `color` will change both thumb and track.
    ///
    /// The following example shows a `RangeSlider` with `.strokeLine`  style and set it's color to green:
    /// ```swift
    /// @State private var selection: ClosedRange<Double> = 20...50
    ///
    /// var body: some View {
    ///     RangeSlider(selection: $selection)
    ///         .thumbStyle(.strokeLine, color: .green)
    /// }
    /// ```
    ///
    /// The resule:
    /// ![green-stroke line](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/green-strokeline.png?raw=true)
    func thumbStyle(_ style: ThumbStyle, color: Color? = .blue, lineWidth: CGFloat? = nil) -> RangeSlider {
        var slider = self
        slider.thumb.style = style
        if let color, style == .strokeLine {
            slider.track.middle = color
            slider.thumb.color = color
        }
        if let lineWidth { slider.thumb.strokeLineWidth = lineWidth }
        return slider
    }
}

public enum ViewVisibility {
    case visible, hidden
}

extension ViewVisibility {
    var isVisible: Bool { self == .visible }
}
