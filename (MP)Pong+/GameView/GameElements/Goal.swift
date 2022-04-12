//
//  Goal.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI

struct Goal: View{
    var color: Color
    var postion: CGPoint
    var body: some View{
        RoundedRectangle(cornerRadius: 25).foregroundColor(color).frame(width: UIScreen.main.bounds.width/1.6, height: 100)
            .position(postion)
    }
}
