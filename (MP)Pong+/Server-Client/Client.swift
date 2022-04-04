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
   
    @Published var manager: SocketManager
    @Published var messages = [String]()
    @Published var serverList: [Int] = []
    
    @Published var location = CGPoint(x: 100, y: 200)
    @Published var socket: SocketIOClient
    
    convenience init(serverType: Int, custom: String){
        var manager: SocketManager
        switch serverType{
        case 1:
            manager = SocketManager(socketURL: URL(string:"ws://192.168.0.19:3000")!, config: [.log(true), .compress])
        case 2:
            manager = SocketManager(socketURL: URL(string:"ws://localHost:3000")!, config: [.log(true), .compress])
        default:
            manager =  SocketManager(socketURL: URL(string:"ws://\(custom):3000")!, config: [.log(true), .compress])
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
    func disconnect(){
        self.socket.disconnect()
    }
    
                          
}
