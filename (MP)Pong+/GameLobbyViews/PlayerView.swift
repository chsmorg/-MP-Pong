//
//  PlayerView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/7/22.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject var client: Client
    @ObservedObject var player: ConnectedPlayer
    @ObservedObject var states: States
    @State var color = Color(.green)
    @State var ballColor = Color(.green)
    var body: some View{
        HStack{
            VStack{
                Text(player.name.capitalized).padding().font(.system(size: 15, design: .rounded)).foregroundColor(self.player.ready ? .green: .white)
                Circle().fill(.radialGradient(Gradient(colors: [self.player.player == 1 ? .green : .red, .white]), center: .center, startRadius: 2, endRadius: 25))
                    .frame(width: 30, height: 30)
            }
            Spacer()
            VStack{
                ZStack{
                    Text("Player").padding(.vertical).font(.system(size: 12)).foregroundColor(.green)
                }
                ZStack{
                    Button(action: {
                        if(self.player.ready==false) {player.setReady()}
                        else{ player.unReady()}
                        if(client.connectedPlayer != nil){
                            client.emitReady(index: states.joinedGame!, ready: self.player.ready)
                        }
                    
                    },label: {
                        Text("Ready").padding()
                            .foregroundColor(self.player.ready ? .green: .red)
                            .cornerRadius(15)
                            .font(.system(size: 15))
                           
                    }).disabled(player.player == 1 ? false : true)
                }
            }
            Spacer()
            VStack{
                Text("Wins: \(self.player.wins)").padding().foregroundColor(.white)
                Text("Streak: \(self.player.streak)").padding().foregroundColor(.white)
            }
            
                .font(.system(size: 15, design: .rounded)).foregroundColor(.black)
        }.padding().background(RoundedRectangle(cornerRadius: 20).fill(.quaternary).frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height/9))
                    }
    
}


