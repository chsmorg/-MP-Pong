//
//  Player.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import Foundation
import SwiftUI
import AVFoundation

class ConnectedPlayer: ObservableObject{
    
    var name: String
    @Published var wins: Int = 0
    @Published var gamesPlayed: Int = 0
    @Published var streak: Int = 0
    @Published var score: Int = 0
    @Published var host: Bool = false
    @Published var connected = false
    @Published var player: Int = 1
    @Published var isBot: Bool = false
    @Published var difficulty: Int = 3
    @Published var ready: Bool = false
    //player positioning
    @Published var startingPosition = CGPoint(x: 0, y: 0)
    @Published var position = CGPoint(x: 0, y: 0)
    @Published var lastPosition = CGPoint(x: 0, y: 0)
    //player physics
    @Published var velocity = simd_float2(x: 0, y: 0)
    @Published var collision = false
    @Published var colTimer = false
    
    init(name: String){
        self.name = name
    }
    func reset(){
        self.velocity = simd_float2(x: 0, y: 0)
        self.position = self.startingPosition
        self.lastPosition = self.startingPosition
        self.collision = false
        self.colTimer = false
    }
    func resetScore(){
        self.score = 0
    }
    func setPlayer(){
        self.isBot = false
        self.unReady()
    }
    func setReady(){
        self.ready = true
    }
    func unReady(){
        self.ready = false
    }
    func setPlayer(pNum: Int){
        self.player = pNum
    }
    func setDif(){
        self.difficulty-=1
        if(self.difficulty == 0){
            self.difficulty = 3
        }
    }
    func scored(){
        self.score+=1
    }
    func gameWon(win:Bool){
        if win{
            self.wins+=1
            self.streak+=1
            self.score = 0
        }
        else{
            self.streak = 0
            self.score = 0
        }
        self.gamesPlayed += 1
    }
    func setStartingPositioning(point: CGPoint){
        self.startingPosition = point
        self.position = point
        self.lastPosition = point
    }
    

}

