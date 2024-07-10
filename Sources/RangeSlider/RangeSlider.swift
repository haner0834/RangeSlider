//
//  RangeSlider.swift
//
//
//  Created by Andy Lin on 2024/7/7.
//

import SwiftUI

/// A control for selecting a range (or two values) from a bounded range of values.
///
/// A `RangeSlider` consists of a "background", two "thumbs", and three "tracks".
///
/// ### Background
/// The "background" is a color used in the slider's background.
///
/// ### Thumbs
/// The "thumb" is a draggable circle used to select a value.
/// The left thumb controls the `lowerBound` of the `selection`,
/// and the right thumb controls the `upperBound` of the `selection`.
///
/// ### Tracks
/// The "tracks" are the rectangular areas that span:
///  - **left**:  From the minimum of the range to the first thumb.
///  - **middle**:  From the first thumb to the second thumb.
///  - **right**:  From the second thumb to the maximum of the range.
///
/// As the user moves the thumbs, the slider updates its bound values.
///
/// ### Usage
/// The following example demonstrates a slider with default modifiers:
/// ```swift
/// @State private var value: ClosedRange<Double> = 20...50
///
/// var body: some View {
///     RangeSlider(
///         value: $value,
///         in: 0...300,
///         onDragging: {
///             print("Hello, world! :D")
///         }
///     )
/// }
/// ```
///
/// The result(default UI settings):
/// ![default view](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/default.png?raw=true)
///
/// You can also use two separate values in one `RangeSlider`.
/// Modifiers are also supported:
///
/// ```swift
/// @State private var lowerBound: Double = 30
/// @State private var upperBound: Double = 80
///
/// var body: some View {
///     RangeSlider(lowerBound: $lowerBound, upperBound: $upperBound)
///         .track(.green)
///         .thumbStyle(.strokeLine, lineWidth: 5)
///         .thumb(color: .green)
///         .thumbShadownHidden()
/// }
/// ```
/// ![strokeline-green-noshadown](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/green-no_shadown-strokeline.png?raw=true)
///
/// - Note: Although there is value-safety checking when initializing the view,
/// having `upperBound` less than `lowerBound` can be performed but is not supported.
/// Because if `upperBound` less than `lowerBound`, 
/// `upperBound` won't update new safe value until user drag the thumb.
///
/// If you want to know more about it, please go to ``init(lowerBound:upperBound:step:in:)``
///
/// Add overlay to thumb is also support:
/// ```swift
/// @State private var selection: ClosedRange<Double> = 20...50
///
/// var body: some View {
///     RangeSlider(selection: $selection) { direction in
///         if direction == .left {
///             // views for left thumb
///             Text(String(format: "%.0d", selection.lowerBound))
///         }else {
///             // views for right thumb
///             Text(String(format: "%.0d", selection.upperBound))
///         }
///     }
/// }
/// ```
///
/// ![withoverlay](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/withoverlay.png?raw=true)
///
/// As you can see, you can customize two different views for left and right thumb through given parameter `direction`,
/// to learn more, please go ``init(selection:in:step:thumbOverlay:)`` or ``init(lowerBound:upperBound:in:step:thumbOverlay:)``.
///
/// While track height larger tahn thumb scale, the slider will be like the image below:
/// ![track-larger-thumb-blue](https://github.com/haner0834/RangeSlider/blob/main/Images/Screenshot/track-larger.png?raw=true)
///
public struct RangeSlider<ThumbOverlay: View>: View {
    //MARK: parameters
    @Binding var selection: ClosedRange<Double>
    var step: CGFloat?
    var range: ClosedRange<CGFloat>
    var thumb: Thumb<ThumbOverlay>
    var track: Track
    var rangeValue: RangeValue
    var onEditingChangePerform: (Bool) -> Void
    
    //MARK: View Properties
    @State private var leftThumb: GestureProperties = .init()
    @State private var rightThumb: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    @State private var isDraging = false
    
    //MARK: Init
    ///Default init
    internal init(selection: Binding<ClosedRange<Double>>,
                  step: CGFloat? = nil,
                  range: ClosedRange<CGFloat> = 1...100,
                  backgroundTing: Color = .primary.opacity(0.16),
                  isShowBackground: Bool = true,
                  leftTint: Color = .clear,
                  rightTint: Color = .clear,
                  stickTint: Color = .accentColor,
                  thumbColor: Color = .white,
                  thumbWidth: CGFloat = 20,
                  thumbStyle: ThumbStyle = .fill,
                  isShowThumbShadown: Bool = true,
                  trackHeight: CGFloat = 5,
                  isShowRangeValue: Bool = false,
                  valueFormat: String = "%.2f",
                  onEditingChangePerform: @escaping (Bool) -> Void = { _ in },
                  @ViewBuilder thumbOverlay: @escaping (Direction) -> ThumbOverlay) {
        _selection = selection
        self.step = step
        self.range = range
        self.thumb = Thumb(color: thumbColor,
                           scale: thumbWidth,
                           isShowShadown: isShowThumbShadown,
                           style: thumbStyle,
                           frontThumbColor: .white,
                           strokeLineWidth: 5,
                           overlay: thumbOverlay)
        self.track = Track(background: backgroundTing,
                           isShowBackground: isShowBackground,
                           left: leftTint,
                           middle: stickTint,
                           right: rightTint,
                           height: trackHeight)
        self.rangeValue = .init(isShow: isShowRangeValue, format: valueFormat)
        self.onEditingChangePerform = onEditingChangePerform
    }
    
    /// Returns thumb scale to calculate.
    ///
    /// if `thumb.scale` larger than `track.height`,
    /// then use `thumb.scale`. Or use `track.height` as `thumb.scale`.
    ///
    /// So whenever `track.height` larger than `thumb.scale`,
    /// the thumb scale to calculate is actually equals height of track.
    var maxThumbScale: CGFloat {
        thumb.scale >= track.height ? thumb.scale: track.height
    }
    
    //MARK: body
    public var body: some View {
        HStack {
            GeometryReader { reader in
                let size = reader.size
//                let maxSliderWidth = reader.size.width - (2 * maxThumbScale)
                let trackHeight = track.height
                
                ZStack(alignment: .leading) {
                    // Background
                    if track.isShowBackground {
                        Capsule()
                            .fill(track.background)
                            .frame(height: trackHeight)
                    }
                    
                    let cornerRadius = trackHeight / 2
                    
                    ZStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            //left range(lower bound to minimum)
                            Rectangle()
                                .frame(width: leftThumb.offset + (maxThumbScale / 2), height: trackHeight)
                                .customForegroundStyle(track.left)
                                .customCornerRadius(in: [.topLeft, .bottomLeft],
                                                    radius: cornerRadius)
                            
                            //middle range(lower bound to upper bound)
                            Rectangle()
                                /// width = indicatorWidth + maxThumbWidth,
                                /// because sum of half of left and right thumb is one thumb.
                                .frame(width: indicatorWidth + maxThumbScale, height: trackHeight)
                                .customForegroundStyle(track.middle)
                            
                            //right range(upper bound to maximum)
                            Rectangle()
                                .frame(height: trackHeight)
                                .customForegroundStyle(track.right)
                                .customCornerRadius(in: [.bottomRight, .topRight],
                                                    radius: cornerRadius)
                        }
                        
                        HStack(spacing: 0) {
                            // Control for lower bound
                            ThumbView(offset: leftThumb.offset, size: size, for: .left) { newValue in
                                processSlider1(size, newValue: newValue)
                            } onEnded: {
                                isDraging = false
                                leftThumb.storeOffset()
                            }
                            
                            // Control for upper bound
                            ThumbView(offset: rightThumb.offset, size: size, for: .right) { newValue in
                                processSlider2(size, newValue: newValue)
                            } onEnded: {
                                isDraging = false
                                rightThumb.storeOffset()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear { initializeDragProperties(size) }
                    .onChange(of: selection) { newValue in
                        if !isDraging {
                            checkValueSafety(newValue: newValue)
                            updateSliderWidth(newValue, size: size)
                        }
                    }
                    .onChange(of: isDraging, perform: onEditingChangePerform)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: max(30, maxThumbScale))
        }
    }
    
    //MARK: - Functions
    func calculateNewRange(_ size: CGSize) {
        calculateIndicatorWidth()
        
        let maxWidth = size.width - (maxThumbScale * 2)
        
        if let step, step > 0 {
            let startProgressWithStep = calculateProgressWithStep(offset: leftThumb.offset, step: step, maxWidth: maxWidth)
            let startProgress = leftThumb.offset == maxWidth ? range.upperBound: startProgressWithStep
            
            let endProgressWithStep = calculateProgressWithStep(offset: rightThumb.offset, step: step, maxWidth: maxWidth)
            let endProgress = rightThumb.offset == maxWidth ? range.upperBound: endProgressWithStep
            
            selection = startProgress...endProgress
        }else {
            let startProgress = leftThumb.offset / maxWidth
            let endProgress = rightThumb.offset / maxWidth
            
            let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
            let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
            
            selection = newRangeStart...newRangeEnd
        }
    }
    //MARK: -
    func calculateProgressWithStep(offset: CGFloat, step: CGFloat, maxWidth: CGFloat) -> CGFloat {
        let maxRange = range.upperBound
        let progress = (offset / maxWidth) * maxRange
        let progressWithStep = round(progress / step) * step
        return progressWithStep
    }
    
    //MARK: -
    func calculateIndicatorWidth() {
        indicatorWidth = rightThumb.offset - leftThumb.offset
    }
    //MARK: -
    func updateSliderWidth(_ newValue: ClosedRange<Double>, size: CGSize) {
        let maxSliderWidth = size.width - (2 * maxThumbScale)
        leftThumb.offset = (newValue.lowerBound / range.upperBound) * maxSliderWidth
        rightThumb.offset = (newValue.upperBound / range.upperBound) * maxSliderWidth
        leftThumb.storeOffset()
        rightThumb.storeOffset()
        calculateIndicatorWidth()
    }
    //MARK: -
    func initializeDragProperties(_ size: CGSize) {
        checkValueSafety()
        
        let maxWidth = size.width - (maxThumbScale * 2)
        
        let lowerProgress = (selection.lowerBound / range.upperBound) * maxWidth
        let upperProgress = (selection.upperBound / range.upperBound) * maxWidth
        
        leftThumb.offset = lowerProgress
        rightThumb.offset = upperProgress
        leftThumb.storeOffset()
        rightThumb.storeOffset()
        
        indicatorWidth = rightThumb.offset - leftThumb.offset
    }
    //MARK: -
    func checkValueSafety(newValue: ClosedRange<Double>? = nil) {
        /// Limite value by minimum to maximum.
        if selection.upperBound > range.upperBound {
            let lowerBound = selection.lowerBound
            let upperBound = Double(range.upperBound)
            
            let newUpperBound = max(lowerBound, upperBound)
            selection = lowerBound...newUpperBound
        }
        
        if selection.lowerBound < range.lowerBound {
            let lowerBound = Double(range.lowerBound)
            let upperBound = selection.upperBound
            
            selection = lowerBound...upperBound
        }
        
        //WHY IT DOESN'T WORK ??????
        ///Limite value to avoid `lowerBound` larger than `upperBound`.
        guard let newValue else { return }
        ///if `newValue` is nil, means it's first call, not for check whether lower bound larger than upper bound
        let oldValue = selection
        if newValue.lowerBound > oldValue.upperBound {
            selection = oldValue.upperBound...oldValue.upperBound
        }
    }
    //MARK: -
    func processSlider2(_ size: CGSize, newValue: DragGesture.Value) {
        // calculating UI
        isDraging = true
        let maxSliderWidth = size.width - (2 * maxThumbScale)
        var transion = newValue.translation.width + rightThumb.lastStoreOffset
        transion = min(max(transion, leftThumb.offset), maxSliderWidth)
        
        if let step, step > 0 {
            let widthStep = (step / range.upperBound) * maxSliderWidth
            let limitedTransion = round(transion / widthStep) * widthStep
            transion = transion >= maxSliderWidth ? maxSliderWidth: max(0, limitedTransion)
        }
        
        rightThumb.offset = transion
        
        // calculating value(`selection`)
        calculateNewRange(size)
    }
    //MARK: -
    func processSlider1(_ size: CGSize, newValue: DragGesture.Value) {
        isDraging = true
        let maxSliderWidth = size.width - (2 * maxThumbScale)
        
        var transion = newValue.translation.width + leftThumb.lastStoreOffset
        transion = min(max(transion, 0), rightThumb.offset)
        
        if let step, step > 0 {
            let widthStep = (step / range.upperBound) * maxSliderWidth
            let limitedTransion = round(transion / widthStep) * widthStep
            transion = transion >= maxSliderWidth ? maxSliderWidth: max(0, limitedTransion)
        }
        
        leftThumb.offset = transion
        
        calculateNewRange(size)
    }
}

fileprivate struct ContentView: View {
    @State private var selection : ClosedRange<Double> = 20...50
    @State private var lowerBound: Double = 70
    @State private var upperBound: Double = 80
    
    var body: some View {
        VStack {
            Slider(value: $lowerBound, in: 0...100)
            
            RangeSlider(lowerBound: $lowerBound, upperBound: $upperBound)
            
            RangeSlider(selection: $selection)
                .thumbStyle(.strokeLine, color: .green)
            
            RangeSlider(selection: $selection, in: 0...100) { direction in
                if direction.isLeft {
                    Text(String(format: "%.0f", selection.lowerBound))
                        .font(.caption)
                }else {
                    Text(String(format: "%.0f", selection.upperBound))
                        .font(.caption)
                }
            }
            .thumb(scale: 30)
            .thumbStyle(.strokeLine)
            .thumb(color: .white)
            .trackBackgroundHidden()
            .thumbShadownHidden()
            .track(height: 40)
            
            RangeSlider(selection: $selection, step: 1) { direction in
                if direction == .left {
                    // views for left thumb
                    Text(String(format: "%.0f", selection.lowerBound))
                }else {
                        // views for right thumb
                    Text(String(format: "%.0f", selection.upperBound))
                }
            }
            .thumb(scale: 30)
            .font(.caption2)
            
            RangeSlider(selection: $selection) { direction in
                Text(String(format: "%.0f", direction == .left ? selection.lowerBound: selection.upperBound))
                    .font(.callout)
            }
            .tint(left: .red.opacity(0.8), middle: .blue.opacity(0.5), right: .green.opacity(0.8))
            .trackBackgroundHidden()
            .thumb(scale: 35)
        }
        .padding()
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
