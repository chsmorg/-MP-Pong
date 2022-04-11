//
//  States.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import Foundation
import SwiftUI
import AVFoundation

class States: ObservableObject {
    @Published var inGame: Bool = false
    @Published var player: ConnectedPlayer
    @Published var playerList: [ConnectedPlayer] = []
    @Published var server: Client
    @Published var debug: Bool = false
    @Published var gamePaused = false
    
    @Published var ballSpeed: Int = 10
    @Published var rounds: Int = 5
    @Published var res: Float = 0.985
    //server info
    @Published var joinedGame: Int? = nil
    @Published var connected: Bool = false
    @Published var status: String = ""
    @Published var connectedPlayers: Int = 0
    @Published var gameEnd = false
    @Published var roundEnd = false
    //game timer
    let timer =  Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()
    //ball physics 
    @Published var ballPosition = CGPoint(x: 0, y: 0)
    @Published var ballVelocity =  simd_float2(x: 0, y: 0)
    
    init(player: ConnectedPlayer, server: Client){
        self.player = player
        self.server = server
        self.addPlayer(player: player)
        self.server.connect()
    }
    
    func updateServerList(){
        self.server.socket.emit("CheckPlayers")
    }
    func connectPlayerToLobby(){
        if(self.playerList.count == 1 && server.connectedPlayer != nil){
            self.addPlayer(player: server.connectedPlayer!)
            if(self.player.host){
                self.server.emitHostInfo(index: joinedGame!, ballSpeed: ballSpeed, rounds: rounds, name: player.name, ready: self.player.ready)
            
            }
        }
        if(self.server.connectedPlayer == nil && self.playerList.count == 2){
            self.removePlayerFromLobby()
        }
        
    }
    func removePlayerFromLobby(){
        self.removePlayer(player: 2)
    }
    
    func restartGame(){
        self.roundEnd = true
        self.gamePaused = false
        self.ballVelocity = simd_float2(x: 0, y: 0)
        
        for p in self.playerList{
            p.resetScore()
            p.reset()
        }
    }
    func setBallPosition(point: CGPoint){
        self.ballPosition = point
    }
    func exitGame(){
        self.endRound(scored: 0)
        self.endGame(winner: 0)
        self.gamePaused = false
    }
    func reset(){
        self.gameEnd = false
        self.roundEnd = false
    }
    func addPlayer(player: ConnectedPlayer){
        self.playerList.append(player)
    }
    func removePlayer(player: Int){
        self.playerList.remove(at: player-1)
    }
    func newRound(){
        self.roundEnd = false
    }
    func resetReady(){
        for p in self.playerList{
            if(p.isBot && p.player == 1){p.setBot()}
            else if !p.isBot {p.setReady()}
        }
    }
    func endRound(scored: Int){
        self.roundEnd = true
        self.ballVelocity = simd_float2(x: 0, y: 0)
        for p in self.playerList{
            if(p.player == scored){
                p.scored()
            }
            p.reset()
        }
    }
    func endGame(winner: Int){
        self.gameEnd = true
        self.resetReady()
        for p in self.playerList{
            if(p.player == winner){
                p.gameWon(win: true)
            }
            else{
                p.gameWon(win: false)
            }
        }
    }
    
    
    
}
