//
//  Client.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import Foundation
import SwiftUI
import SocketIO

final class Client: ObservableObject{
    @Published var serverType: Int
    @Published var custom: String
    @Published var connected = false
    @Published var failed = false
    @Published var connectedPlayers: Int = 0
    @Published var status = ""
    
    @Published var gameJoined = false
    @Published var gameConnected = false
    @Published var playerNum = 0
    @Published var connectedPlayer: ConnectedPlayer? = nil
   
    @Published var manager: SocketManager
    @Published var messages = [String]()
    @Published var serverList: [Int] = []
    
    @Published var location = CGPoint(x: 100, y: 200)
    @Published var rounds: Int = 5
    @Published var ballSpeed: Int = 15
    
    @Published var socket: SocketIOClient
    
    convenience init(serverType: Int, custom: String){
        var manager: SocketManager
        switch serverType{
        case 1:
            manager = SocketManager(socketURL: URL(string:"ws://192.168.0.19:11328")!, config: [.log(true), .compress])
        case 2:
            manager = SocketManager(socketURL: URL(string:"ws://35.129.56.107:11328")!, config: [.log(true), .compress])
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
            self.connected = false
        }
        socket.on(clientEvent: .statusChange){ (data, ack) in
            self.status = self.socket.status.description
        }
        socket.on(clientEvent: .error){ (data, ack) in
            self.status = self.socket.status.description
            self.disconnect()
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
        socket.on("testmmsg"){ [weak self](data, ack) in
            if let data = data[0] as? [String: String],
               let rawMessage = data["msg"] {
                DispatchQueue.main.async {
                    self?.messages.append (rawMessage)
                }
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
        
        
        socket.on("position"){ [weak self](data, ack) in
            if let data = data[0] as? [String: [Double]],
               let rawMessage = data["newp"] {
                DispatchQueue.main.async {
                    self?.location = CGPoint(x: rawMessage[0], y: rawMessage[1])
                }
            }
        }
        
    }
    func updateList(){
        self.socket.emit("CheckPlayers")
        self.socket.emit("CheckServers")
        print(self.serverList)
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
    func disconnect(){
        self.socket.disconnect()
        self.gameJoined = false
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
    
                          
}
