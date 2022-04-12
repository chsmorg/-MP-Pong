//
//  ScoreCounterLayOut.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI

struct ScoreCounterLayOut: View {
    @ObservedObject var player: ConnectedPlayer
    @State var rounds: Int
    var body: some View {
        HStack{
            if rounds <= 5 {
                VStack(spacing: 3){
                    ForEach(1...rounds, id: \.self){num in
                        ScoreCounterDot(ballNum: num, player: player, color : self.player.player == 1 ? .green : .red)
                    }
                }.padding()
            }
            else {
                VStack(spacing: 3){
                    ForEach(1...5, id: \.self){num in
                        ScoreCounterDot(ballNum: num, player: player, color : self.player.player == 1 ? .green : .red)
                    }
                }.padding(self.player.player == 1 ? .leading : .bottom)
                VStack(spacing: 3){
                    ForEach(6...rounds, id: \.self){num in
                        ScoreCounterDot(ballNum: num, player: player, color : self.player.player == 1 ? .green : .red)
                    }
                }.padding(self.player.player == 2 ? .trailing : .bottom)
            }
        }
    }
}


