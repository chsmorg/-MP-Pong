//
//  PlayerSprite.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI

import SwiftUI
import AVFoundation

struct PlayerSprite: View {
    let bounds = UIScreen.main.bounds
    @ObservedObject var states: States
    @ObservedObject var player: ConnectedPlayer
    @ObservedObject var physics: Physics
    @State var colTimer = false
    
    
    @State var side:CGFloat = 0
    
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                    if(!states.roundEnd ){
                        if(value.location.y > side){
                            self.player.lastPosition = self.player.position
                            self.player.position = value.location
                       }
                    }
                }
            }
 
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [self.player.player == 1 ? .green : .red, .white]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(player.position)
            .gesture(
                simpleDrag
            ).onAppear(){
                if(self.player.player == 1){
                    side = bounds.height/2+30
                }
                else{
                    side = bounds.height/2-30
                }
            }.onReceive(self.states.timer){ _ in
                    physics.update()
                
            }
    }
  
    
}

