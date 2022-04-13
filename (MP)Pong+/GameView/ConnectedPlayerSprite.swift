//
//  ConnectedPlayerSprite.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/13/22.
//

import SwiftUI

struct ConnectedPlayerSprite: View {
    @ObservedObject var player: ConnectedPlayer
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [.green, .white]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(player.position)
    }
}


