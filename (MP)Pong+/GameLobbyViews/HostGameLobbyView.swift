//
//  HostGameLobbyView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/7/22.
//


import SwiftUI

private let bounds = UIScreen.main.bounds

struct HostGameLobbyView: View {
    @ObservedObject var states: States
    @State var connectedPlayers = 1
    @Binding var lobbyScreen: Bool
    @State var gameNum: Int
    @State var connectionStatus = "Joining..."
    @State var joined = false
    @State var timer = 150
    @State var gameReady = false
    @State var gameStart = false
    var body: some View {
            ZStack{
                if joined {
                    VStack{
                        ScrollView([], showsIndicators: false){
                            ForEach(0...states.playerList.count-1, id: \.self) { index in
                                PlayerView(client: states.server, player: states.playerList[index])
                            }
                        }
                        GameOptionsView(states: states, client: states.server, player: states.player).padding()
                    }
                    if(states.player.host){
                        Button(action:{
                            gameStart = true
                            states.reset()
                        },label:{
                            Text("Start Game")
                                .padding(15)
                                .foregroundColor(.black)
                                .font(.system(size: 30, design: .rounded))
                                .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height/12)
                               .background(RoundedRectangle(cornerRadius: 45)
                                .fill(.cyan)
                                    .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height/12)
                                    .padding(4))
                        }).opacity(self.gameReady ? 0.8 : 0).shadow(radius: 70)
                            .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height/12)
                    }
                }
                else{
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Text(connectionStatus).foregroundColor(.cyan).font(.system(size: 25, design: .rounded)).padding(.horizontal)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                

            }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500))
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .foregroundColor(.cyan).opacity(0.9)
                .onReceive(self.states.timer){_ in
                    updateLobby()
                }
    }
    
    
    
    func updateLobby(){
        
        //connection status
        if(states.server.gameConnected && states.server.playerNum != 0){
            //setting lobby host
            if self.states.server.playerNum == 1{
                self.states.player.host = true
            }
            self.joined = true
            //ready status
            if(self.states.playerList.count == 2){
                if(self.states.playerList[0].ready && self.states.playerList[1].ready){
                    gameReady = true
                }
                else {gameReady = false}
            }
        
            states.connectPlayerToLobby()
            //update timer
            timer -= 1
            if(timer <= 0){
                timer = 150
            }
        }
        
        else{
            self.joined = false
        }
    }
}








