//
//  ServerListElement.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/4/22.
//

import SwiftUI


struct ServerListElement: View {
    @ObservedObject var client: Client
    @ObservedObject var states: States
    @Binding var joining: Bool
    var bounds = UIScreen.main.bounds
    var serverNum: Int
    var connectedPayers: Int
    var active: Bool
    
    var body: some View{
        HStack{
            //ServerElementPic()
            VStack{
                HStack{
                    Text("Game: \(serverNum+1)").foregroundColor(.cyan).font(.system(size: 20, design: .rounded)).padding(.leading)
                }
                Spacer()
                HStack{
                    Text("\(connectedPayers)/2").foregroundColor(connectedPayers == 2 ? .red : .green).font(.system(size: 15, design: .rounded)).padding(.leading)
                    Text(active ? "Playing": "Lobby").foregroundColor(active ? .red : .orange).font(.system(size: 15, design: .rounded))
                }
            }
            Spacer()
            
                Image(systemName: "arrow.right.circle").font(.system(size: 30, design: .rounded)).padding()
                    .foregroundColor(.cyan)
            
        
        
        }.background(RoundedRectangle(cornerRadius: 20).fill(.quaternary).frame(width: UIScreen.main.bounds.width-50, height: bounds.height/9))
            .onTapGesture{
                if(!client.gameJoined && connectedPayers < 2){
                    client.join(index: serverNum, name: states.player.name)
                    client.gameJoined = true
                    states.joinedGame = serverNum
                    joining = true
                }
                
            
            }
    }
}
