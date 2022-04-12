//
//  GameCircle.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI

import SwiftUI

struct GameCircle: View {
    let radius: CGFloat = 70
    var body: some View {
        Circle()
            .stroke(.secondary, style: StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [5], dashPhase: 0))
            .frame(width: radius * 2, height: radius * 2)
        
    }
}

