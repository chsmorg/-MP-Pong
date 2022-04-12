//
//  Line.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
        return path
    }
}
