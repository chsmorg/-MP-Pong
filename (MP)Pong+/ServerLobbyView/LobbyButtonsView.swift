//
//  LobbyButtonsView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/11/22.
//

import SwiftUI

struct LobbyButtonsView: View {
    @ObservedObject var states: States
    @ObservedObject var client: Client
    @Binding var joining: Bool
    @State var invites: Int = 0
    var body: some View {
        HStack{
            Button(action: {
                client.updateList()
                var i = client.serverList.count-1
                while i >= 0{
                    if client.serverList[i] == 1{
                        client.join(index: i, name: states.player.name)
                        client.gameJoined = true
                        states.joinedGame = i
                        joining = true
                        break
                    }
                    i -= 1
                }
                
            },label: {
                Text("Find Match").padding().font(.system(size: 13, design: .rounded))
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 45)
                        .foregroundColor(.cyan)
                        .frame(height: 40))
                   
            }).padding().opacity(0.8)
            
            Button(action: {
                client.updateList()
                var i = client.serverList.count-1
                while i >= 0{
                    if client.serverList[i] == 0{
                        client.join(index: i, name: states.player.name)
                        client.gameJoined = true
                        states.joinedGame = i
                        joining = true
                        break
                    }
                    i -= 1
                }
                
            },label: {
                Text("Host Match").padding().font(.system(size: 13, design: .rounded))
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 45)
                        .foregroundColor(.cyan)
                        .frame(height: 40))
                   
            }).padding().opacity(0.8)
        }
    }
}

