//
//  PlayerSprite.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

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
        Circle().fill(.radialGradient(Gradient(colors: [.green, .white]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(player.position)
            .gesture(
                simpleDrag
            ).onAppear(){
                side = bounds.height/2+30
            }.onReceive(self.states.timer){ _ in
                if self.player.host{
                    physics.update()
                }
                else{
                    player.velocity = physics.calcVelocity()
                    if(states.joinedGame != nil){
                        states.server.emitPlayerSpriteInfo(index: states.joinedGame!, posX: bounds.width - self.player.position.x , posY: bounds.height - self.player.position.y, velX: player.velocity.x * -1 , velY: player.velocity.y * -1)
                    }
                    
                }
                    
                
            }
    }
  
    
}

