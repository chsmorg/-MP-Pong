//
//  Client.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import Foundation
import AVFoundation
import SwiftUI
import SocketIO

final class Client: ObservableObject{
    ///server type when connecting to a server
    @Published var serverType: Int
    ///custom server ip
    @Published var custom: String
    ///ack when connected to a server
    @Published var connected = false
    ///ack when failing to connect to a sercer
    @Published var failed = false
    ///amount of players connected
    @Published var connectedPlayers: Int = 0
    ///amount of servers active
    @Published var serverList: [Int] = []
    ///status of connection
    @Published var status = ""
    ///spot player connected in lobby
    @Published var playerNum = 0
    
    ///client side ack when joining a lobby
    @Published var gameJoined = false
    ///server ack when joining a lobby
    @Published var gameConnected = false
    ///current player connected to
    @Published var connectedPlayer: ConnectedPlayer? = nil
    @Published var connectedBallPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    @Published var gameStart = false
    @Published var roundEnd = true
    @Published var gameWon = false
    @Published var gameEnd = false
    @Published var score = 0
   
    @Published var manager: SocketManager
    
    
    ///defualt game info
    @Published var location = CGPoint(x: 100, y: 200)
    @Published var rounds: Int = 5
    @Published var ballSpeed: Int = 15
    
    @Published var socket: SocketIOClient
    
    convenience init(serverType: Int, custom: String){
        var manager: SocketManager
        switch serverType{
        case 1:
            //192.168.0.19
            manager = SocketManager(socketURL: URL(string:"ws://35.129.56.107:11328")!, config: [.log(true), .compress])
        case 2:
            //35.129.56.107
            manager = SocketManager(socketURL: URL(string:"ws:localhost//:11328")!, config: [.log(true), .compress])
        default:
            manager =  SocketManager(socketURL: URL(string:"ws://\(custom):11328")!, config: [.log(true), .compress])
        }
        self.init(serverType: serverType, customIP: "", manager: manager)
    }
    
    init(serverType: Int, customIP: String, manager: SocketManager){
        self.serverType = serverType
        self.custom = customIP
        self.manager = manager
        
        self.socket = manager.defaultSocket
        socket.on(clientEvent: .connect){ (data, ack) in
            
            self.failed = false
            self.updateList()
            self.connected = true
        }
        socket.on(clientEvent: .disconnect){ (data, ack) in
            self.reset()
        }
        socket.on(clientEvent: .statusChange){ (data, ack) in
            self.status = self.socket.status.description
        }
        socket.on(clientEvent: .error){ (data, ack) in
            self.status = self.socket.status.description
            self.disconnect()
        }
        socket.on(clientEvent: .pong){ (data, ack) in
            
        }
        socket.on("ActiveServers"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Int]],
               let servers = data["SInfo"] {
                DispatchQueue.main.async {
                    self?.serverList = servers
                }
            }
        }
        
        socket.on("ActivePlayers"){ [weak self](data, ack) in
            if let data = data[0] as? [String: Int],
               let players = data["PInfo"] {
                DispatchQueue.main.async {
                    self?.connectedPlayers = players
                }
            }
        }
        socket.on("GameStart"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Bool]],
               let start = data["start"] {
                DispatchQueue.main.async {
                    self?.gameStart = start[0]
                }
            }
        }
        socket.on("GameEnd"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Bool]],
               let won = data["winner"] {
                DispatchQueue.main.async {
                    self?.gameWon = won[0]
                    self?.gameEnd = true
                }
            }
        }
        socket.on("endRound"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Bool]],
               let scored = data["round"] {
                DispatchQueue.main.async {
                    self?.roundEnd = true
                    if scored[0]{
                        self?.score += 1
                    }
                    else{
                        if self?.connectedPlayer != nil{
                            self?.connectedPlayer!.scored()
                        }
                        
                    }
                    
                }
            }
        }
        socket.on("GameStartAck"){[weak self] _,_ in
            DispatchQueue.main.async {
                self?.gameStart = true
            }
        }
        socket.on("endRoundAck"){[weak self] _,_ in
            DispatchQueue.main.async {
                self?.roundEnd = true
            }
        }
        socket.on("PlayerNum"){ [weak self](data, ack) in
            if let data = data[0] as? [String: Int],
               let number = data["Pnum"] {
                DispatchQueue.main.async {
                    self?.playerNum = number
                    self?.gameConnected = true
                }
            }
        }
        socket.on("LobbyInfo"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Int]],
               let info = data["info"] {
                DispatchQueue.main.async {
                    self?.ballSpeed = info[0]
                    self?.rounds = info[1]
                }
            }
        }
        
        socket.on("Ready"){ [weak self](data, ack) in
            if let data = data[0] as? [String: Int],
               let ready = data["Rstatus"] {
                DispatchQueue.main.async {
                    if(ready == 0){
                        self?.connectedPlayer?.ready = false
                    }
                    else{
                        self?.connectedPlayer?.ready = true
                    }
                    
                }
            }
        }
        socket.on("ConnectedPlayerName"){ [weak self](data, ack) in
            if let data = data[0] as? [String: String],
               let name = data["Pname"] {
                DispatchQueue.main.async {
                    self?.connectedPlayer = ConnectedPlayer(name: name)
                    self?.connectedPlayer?.player = 2
                }
            }
        }
        socket.on("ConnectedPlayerInfo"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Double]],
               let pData = data["CPinfo"] {
                DispatchQueue.main.async {
                   let pos = CGPoint(x: pData[0], y: pData[1])
                   let vel = simd_float2(x: Float(pData[2]), y: Float(pData[2]))
                    self?.connectedPlayer?.velocity = vel
                    self?.connectedPlayer?.position = pos
                }
            }
        }
        socket.on("GamePositions"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Double]],
               let positions = data["Ginfo"] {
                DispatchQueue.main.async {
                   let ppos = CGPoint(x: positions[0], y: positions[1])
                   let bpos = CGPoint(x: positions[2], y: positions[3])
                    self?.connectedPlayer?.position = ppos
                    self?.connectedBallPosition = bpos
                }
            }
        }
        
        
        socket.on("position"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Double]],
               let rawMessage = data["newp"] {
                DispatchQueue.main.async {
                    self?.location = CGPoint(x: rawMessage[0], y: rawMessage[1])
                }
            }
        }
        socket.on("playerLeft"){ (data, ack) in
            self.connectedPlayer = nil
            if(self.playerNum == 2){
                self.playerNum = 1
            }
            if(self.gameStart){
                self.gameStart = false
            }
        }
        
    }
    func updateList(){
        self.socket.emit("CheckPlayers")
        self.socket.emit("CheckServers")
    }
    
    func reset(){
        self.connected = false
        self.connectedPlayer = nil
        self.gameConnected = false
        self.gameJoined = false
        self.gameStart = false
    }
    func leaveLobby(){
        self.socket.emit("leave")
        self.connectedPlayer = nil
        
        self.playerNum = 0
        self.gameJoined = false
        self.gameConnected = false
    }
    
    func connect(){
        self.socket.connect(timeoutAfter: 5, withHandler: {
            self.failed = true
        })
    }
    func join(index: Int, name: String){
        self.socket.emit("join", [String(index),name])
        self.gameJoined = true
        
    }
    func startGame(start: Bool, index: Int){
        self.socket.emit("GameStart", [index, start])
    }
    func endRound(scored: Bool, index: Int){
        self.socket.emit("endRound", [index, scored])
    }
    func gameEnd(winner: Bool, index: Int){
        self.socket.emit("GameEnd", [index, winner])
    }
    func disconnect(){
        self.socket.disconnect()
    }
    func emitHostInfo(index: Int, ballSpeed: Int, rounds: Int, name: String, ready: Bool){
        var r = 0
        if ready{
            r = 1
        }
        self.socket.emit("joinAckName", [String(index), name])
        self.socket.emit("lobbyInfo", [index,ballSpeed,rounds])
        self.socket.emit("ready", [index, r])
    }
    func emitLobbyInfo(index: Int, ballSpeed: Int, rounds: Int){
        self.socket.emit("lobbyInfo", [index,ballSpeed,rounds])
    }
    func emitReady(index: Int, ready: Bool){
        var r = 0
        if ready{
            r = 1
        }
        self.socket.emit("ready", [index, r])
    }
    
    //in game data
    
    func emitPlayerSpriteInfo(index: Int, posX: Double, posY: Double, velX: Float, velY: Float){
        let arr = [posX,posY, Double(velX),Double(velY)]
        self.socket.emit("ConnectedPlayerInfo", [index, arr])
    }
    
    func emitGamePositions(index: Int, player: CGPoint, ball: CGPoint, bounds: CGRect){
        if(self.gameStart){
            self.socket.emit("GamePositions", [index, [bounds.width - player.x, bounds.height - player.y, bounds.width - ball.x, bounds.height - ball.y]])
        }
        
    }
    func resetGameElements(){
        if(self.connectedPlayer != nil){
            self.connectedPlayer?.reset()
            self.connectedPlayer?.resetScore()
        }
        self.score = 0
        self.gameEnd = false
        self.roundEnd = true
        self.gameWon = false
    }
    
                          
}
