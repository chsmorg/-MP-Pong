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
    
    @Published var ballSpeed: Int = 10
    @Published var rounds: Int = 5
    @Published var res: Float = 0.985
    //server info
    @Published var joinedGame: Int? = nil
    @Published var gameEnd = false
    @Published var roundEnd = false
    //game timer
    let timer =  Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
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
            self.removePlayer()
            self.player.ready = false
        }
        
    }
    
    func setBallPosition(point: CGPoint){
        self.ballPosition = point
    }
    func exitGame(){
        self.server.gameStart = false
        self.server.roundEnd = true
        self.server.score = 0
        self.endRound(scored: false)
        self.gameEnd = true
        self.player.unReady()
        self.server.gameWon = false
        self.server.gameEnd = false
        if self.playerList.count == 2{
            playerList[1].gameWon(win: false)
        }
    }
    func reset(){
        self.gameEnd = false
        self.roundEnd = false
        self.server.resetGameElements()
    }
    func addPlayer(player: ConnectedPlayer){
        self.playerList.append(player)
    }
    func exitLobby(){
        self.server.gameStart = false
        self.removePlayer()
        self.player.ready = false
        if(self.inGame){
            self.player.gameWon(win: false)
        }
        self.server.leaveLobby()
        self.joinedGame = nil
    }
    func removePlayer(){
        if(self.playerList.count == 2){
            self.playerList.remove(at: 1)
        }
        
    }
    func newRound(){
        self.server.roundEnd = false
        self.roundEnd = false
    }
    func endRound(scored: Bool){
        if(self.joinedGame != nil && self.server.connectedPlayer != nil){
            self.server.endRound(scored: scored, index: self.joinedGame!)
            if scored{
                self.playerList[0].scored()
            }
            else{
                self.playerList[1].scored()
            }
        }
        self.player.reset()
        self.ballVelocity = simd_float2(x: 0, y: 0)
    }
    func endGame(winner: Bool){
        self.exitGame()
        if(self.server.connectedPlayer != nil && self.player.host){
            self.server.gameEnd(winner: !winner, index: self.joinedGame!)
        }
        self.playerList[0].gameWon(win: winner)
        self.playerList[1].gameWon(win: !winner)
    }
    
    
    
}
