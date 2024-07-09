//
//  OverlayModifier.swift
//  
//
//  Created by Andy Lin on 2024/6/18.
//

import Foundation
import SwiftUI

struct OverlayModifier<Overlay: View>: ViewModifier {
    let overlay: Overlay
    let alignment: Alignment
    
    init(alignment: Alignment = .center, @ViewBuilder overlay: () -> Overlay) {
        self.overlay = overlay()
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            content
            overlay
        }
    }
}
