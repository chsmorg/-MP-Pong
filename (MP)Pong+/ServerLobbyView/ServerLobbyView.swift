//
//  ServerLobbyView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/3/22.
//

import SwiftUI

struct ServerLobbyView: View {
    @ObservedObject var states: States
    @State var startUp = true
    @State var loading = true
    @State var connected = false
    @State var startUpText: String = "Connecting"
    @Binding var screen: Bool
    @State var timer = 150
    var body: some View {
            ZStack{
                
                
            
                    VStack{
                        
                        ServerInfoView(client: states.server, screen: $screen)
                       
                        //StatsView()
                        if(self.connected){
                                ServerListView(client: states.server)
                            
                           // LobbyButtonsView()
                            
                       }
                        

                        Spacer()

                    }
            
                
                
                
            }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500)).onReceive(self.states.timer){_ in
                if(self.states.server.connected){
                    if(!self.states.server.serverList.isEmpty){
                        self.connected = true
                    }
                       
                
                   
                    timer -= 1
                    if(timer <= 0){
                        self.states.server.updateList()
                        timer = 150
                        
                    }
                }
                else{
                    self.connected = false
                }
                
                
            }
            .onAppear(){
                //states.connect()
            }
            .navigationBarTitle("")
             .navigationBarHidden(true)
                
        
        
        
    }
}

