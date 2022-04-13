//
//  ConnectedBallSprite.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/13/22.
//

import SwiftUI

struct ConnectedBallSprite: View {
    @ObservedObject var states: States
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [.black, .gray]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(self.states.ballPosition)
    }
}


