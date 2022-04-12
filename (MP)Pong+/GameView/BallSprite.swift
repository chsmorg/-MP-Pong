//
//  BallSprite.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI
import AVFoundation
private let bounds = UIScreen.main.bounds

struct BallSprite: View {
    @ObservedObject var states: States
    @ObservedObject var physics: Physics
    
    let player1GoalPosition = CGPoint(x: bounds.width/2, y: bounds.height-70)
    let player2GoalPosition = CGPoint(x: bounds.width/2, y: 70)
    let ballStart = CGPoint(x: bounds.width/2, y: bounds.height/2)
    
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [.black, .gray]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(self.states.ballPosition).onAppear(){
                states.ballPosition = ballStart
            }.onReceive(self.states.timer){ _ in
                physics.updateBall(bounds: bounds)
                
                
            }
    }
    
    
}

