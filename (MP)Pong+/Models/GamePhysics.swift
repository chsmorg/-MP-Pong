//
//  GamePhysics.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//


import Foundation
import SwiftUI
import AVFoundation

class Physics: ObservableObject{
    var states: States
    var player: ConnectedPlayer
    
    init(states: States){
        self.states = states
        self.player = self.states.player
    }
    init(states: States, player: ConnectedPlayer){
        self.states = states
        self.player = player
    }
    
    func findDirection(point1: CGPoint, point2: CGPoint) -> simd_float2{
        let p1 = point1
        let p2 = point2
        let delta = simd_float2(x: Float(p2.x - p1.x), y: Float(p2.y - p1.y))
        return simd_normalize(delta)
        
    }
    func findDistance(point1: CGPoint, point2: CGPoint) -> Float{
        let p1 = point1
        let p2 = point2
        let delta = simd_float2(x: Float(p2.x - p1.x), y: Float(p2.y - p1.y))
        return simd_length(delta)
        
    }
    
    
    func update(){
        if(!states.roundEnd && !states.gameEnd){
            player.velocity = calcVelocity()
            if checkCollision(ballPosition: self.states.ballPosition){resolveCollision()}
        }
        else{player.position = self.player.startingPosition}
    }
    
    func updateBall(bounds: CGRect){
        let p = self.states.ballPosition
            withAnimation{
                redGoalCollision(bounds: bounds)
                greenGoalCollision(bounds: bounds)
                if(p.y>bounds.height || p.y < 0 || p.x < 0 || p.x > bounds.width){states.ballPosition = CGPoint(x: bounds.width/2, y: bounds.height/2)}
                if(!states.roundEnd){
                    wallCollisionCheck(bounds: bounds)
                    states.ballPosition.x += Double(self.states.ballVelocity.x)
                    states.ballPosition.y += Double(self.states.ballVelocity.y)
                    states.ballVelocity = self.states.ballVelocity * self.states.res
                }
        }
    }
    
    func calcVelocity() -> simd_float2{
        let a = simd_double2(x: (self.player.lastPosition.x), y: (self.player.lastPosition.y))
        let b = simd_double2(x: (self.player.position.x), y: (self.player.position.y))
        let d = simd_distance(a, b)
        let s = d/0.05
        let v = simd_float2(x: Float(s/d*(player.position.x - player.lastPosition.x)),
                            y: Float(s/d*(player.position.y - player.lastPosition.y)))
        
        if(!v.x.isNaN && !v.y.isNaN){return v}
        return self.player.velocity

    }
    
    func checkCollision(ballPosition: CGPoint) -> Bool{
        let dx = (self.player.position.x + 30) - (ballPosition.x + 30);
        let dy = (self.player.position.y + 30) - (ballPosition.y + 30);
        let distance = sqrt(dx*dx + dy*dy)
        if(distance<60){ return true }
        return false
        
    }
    
    func resolveCollision(){
        let v1 = self.player.velocity
        let v2 = self.states.ballVelocity
        let p1 = self.player.position
        let p2 = self.states.ballPosition
        let m1: Float  = 30
        let m2: Float = 25
        
        
        let normal = simd_float2(x: Float(p2.x - p1.x), y: Float(p2.y - p1.y))
        let d =  simd_length(normal)
        let un = simd_normalize(normal)
        let ut = simd_float2(x: -un.y, y: un.x)
        if(d != 0){
           let mtd = normal*((60-d)/d)
            withAnimation(){
                states.ballPosition.x += Double(mtd.x)
                states.ballPosition.y += Double(mtd.y)
            }
        }
        //player
        let v1n = simd_dot(un, v1)
        //ball
        var v2n = simd_dot(un, v2)
        let v2t = simd_dot(ut, v2)
        v2n = (v2n*(m2-m1)+2*m2*v1n)/(m1+m2)
        
        let newVn = v2n * un
        let newVt = v2t * ut
        
       // var newV1 = newV1n + newV1t
        var newV = (newVn + newVt)*0.2
        
        if(newV.x > Float(self.states.ballSpeed)){
                    newV.x = Float(self.states.ballSpeed)
                }
                if(newV.y > Float(self.states.ballSpeed)){
                    newV.y = Float(self.states.ballSpeed)
                }
                if(newV.x < Float(self.states.ballSpeed) * -1){
                    newV.x = Float(self.states.ballSpeed) * -1
                }
                if(newV.y < Float(self.states.ballSpeed) * -1){
                    newV.y = Float(self.states.ballSpeed) * -1
        
                }
        //Haptics.shared.play(.medium)
        states.ballVelocity = newV
    }
    
    func wallCollisionCheck(bounds: CGRect){
        var incident: simd_float2
        var normal: simd_float2
        let bx = self.states.ballPosition.x
        let by = self.states.ballPosition.y
        if(bx < 30){
            incident = self.states.ballVelocity
            normal = simd_float2(x: 1, y: 0)
            states.ballVelocity = simd_reflect(incident, normal)
            //Haptics.shared.play(.soft)
        }
        if(bx > bounds.width-30){
            incident = self.states.ballVelocity
            normal = simd_float2(x: -1, y: 0)
            states.ballVelocity = simd_reflect(incident, normal)
            //Haptics.shared.play(.soft)
        }
        if(by < 60){
            incident = self.states.ballVelocity
            normal = simd_float2(x: 0, y: 1)
            states.ballVelocity = simd_reflect(incident, normal)
           // Haptics.shared.play(.soft)
        }
        if(by > bounds.height-60){
            incident = self.states.ballVelocity
            normal = simd_float2(x: 0, y: -1)
            states.ballVelocity = simd_reflect(incident, normal)
            //Haptics.shared.play(.soft)
        }
    }
    
    func redGoalCollision(bounds: CGRect){
        let player2GoalPosition = CGPoint(x: bounds.width/2, y: 70)
        
        if (abs(Float(player2GoalPosition.x - self.states.ballPosition.x)) < 120 && (abs(Float(player2GoalPosition.y - self.states.ballPosition.y)) <
          20)){
           
             states.ballPosition = CGPoint(x: bounds.width/2, y: bounds.height/2.5)
             states.endRound(scored: 1)
            // Haptics.shared.notify(.success)
             
            
    
            if(states.playerList[0].score == states.rounds){
                states.endGame(winner: 1)
            }
        }
    }
    
    func greenGoalCollision(bounds: CGRect){
        let player1GoalPosition = CGPoint(x: bounds.width/2, y: bounds.height-70)
        
        if (abs(Float(player1GoalPosition.x - self.states.ballPosition.x)) < 120 && (abs(Float(player1GoalPosition.y - self.states.ballPosition.y)) <
          20)){
           
            states.ballPosition = CGPoint(x: bounds.width/2, y: bounds.height/1.5)
            states.endRound(scored: 2)
            //Haptics.shared.notify(.error)
            
            if(states.playerList[1].score == states.rounds){
                states.endGame(winner: 2)
            }
        }
    }

}

