//
//  GameOptionsView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/7/22.
//

import SwiftUI


struct GameOptionsView: View{
    @ObservedObject var states: States
    @ObservedObject var client: Client
    @State var player: ConnectedPlayer
    @State var rounds: Double = 5
    @State var ballSpeed: Double = 10
    var body: some View{
        VStack{
            Divider()
            Text("Game Settings:").font(.system(size: 20))
            Text("Rounds: \(Int(states.rounds))").font(.system(size: 20, design: .rounded))
            if(player.host){
                Slider(value: $rounds, in: 1...10).accentColor(.cyan).padding().onChange(of: rounds){
                    num in
                    states.rounds = Int(rounds)
                    
                }
            }
            Text("Ball Speed: \(Int(states.ballSpeed))").font(.system(size: 20, design: .rounded))
            if(player.host){
                Slider(value: $ballSpeed, in: 10...25).accentColor(.cyan).padding().onChange(of: ballSpeed){
                    num in
                    states.ballSpeed = Int(ballSpeed)
                }
            }
                            
        }.onAppear(){
            ballSpeed = Double(states.ballSpeed)
            rounds = Double(states.rounds)
        }
        .onChange(of: states.rounds){ _ in
            if(states.playerList.count == 2){
                client.emitLobbyInfo(index: states.joinedGame!, ballSpeed: states.ballSpeed, rounds: states.rounds)
            }
            
        }
        .onChange(of: states.ballSpeed){ _ in
            if(states.playerList.count == 2){
                client.emitLobbyInfo(index: states.joinedGame!, ballSpeed: states.ballSpeed, rounds: states.rounds)
            }
        }

            
    }
    
}

