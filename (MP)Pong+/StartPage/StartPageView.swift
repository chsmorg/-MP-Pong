//
//  StartPageView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import SwiftUI


struct StartPageView: View {
    @State var name = ""
    //@State var states = States(player: ConnectedPlayer(name: ""))
    @State var validName = false
    @State var lobbyType: Int = 1
    @State var serverType: Int = 1
    @State var customServer: String = ""
    @State var settingsVis = true
    @State var statusText = ""
    @State var lobby = false
    @State var connected = false
    @State var help = false
    var body: some View {
        NavigationView{
                VStack{
                    ZStack{
                        DropDownView(lobbyType: $lobbyType, serverType: $serverType, customServer: $customServer).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.3).opacity(settingsVis ? 1 : 0)
                        DropDownServerView(lobbyType: $lobbyType, serverType: $serverType, customServer: $customServer).position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.3).opacity(settingsVis ? 1 : 0)
                        
                        AnimationView().position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/7)
                        VStack{
                            if(lobby){
                                    let player = ConnectedPlayer(name: name)
                                    let server = Client(serverType: serverType, custom: customServer)
                                    let states = States(player: player, server: server)
                                    NavigationLink(destination: ServerLobbyView(states: states, screen: $lobby), isActive: $lobby) {
                                       EmptyView()
                                   
                                }
                                     
                                
                            }
                            else if help{
                                
                            }
                            
                            Spacer()
                            
                            TextField("Name:", text: $name).padding().background(.quaternary).cornerRadius(15).autocapitalization(.none)
                                .keyboardType(.default)
                                .disableAutocorrection(true)
                                .foregroundColor(.white)
                                .onSubmit{
                                    self.settingsVis = true
                                    if(!name.isEmpty && name.count >= 3 && name.count <= 8){
                                        validName = true
                                    }
                                    else{
                                        validName = false
                                    }
                                }.onTapGesture {
                                    withAnimation(.spring()){
                                        self.settingsVis = false
                                    }
                                    
                                }
                            
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    if(validName){
                                        self.lobby = true
                                    }
                                },label: {
                                    Text("Start").padding().frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/15)
                                        .foregroundColor(.black)
                                        .background(RoundedRectangle(cornerRadius: 45).frame(width: UIScreen.main.bounds.width/3).foregroundColor(validName ? .green: .red))
                                       
                                }).padding().opacity(0.8).frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/15).shadow(radius: 70)
                                Spacer()
                                
                                
                                Button(action: {
                                        self.help = true
                                    
                                },label: {
                                    Text("How To Play").padding().frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/15)
                                        .foregroundColor(.black)
                                        .background(RoundedRectangle(cornerRadius: 45).frame(width: UIScreen.main.bounds.width/3).foregroundColor(.cyan))
                                        
                                       
                                }).padding().opacity(0.8).frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/15).shadow(radius: 70)
                                Spacer()
                                
                            }
                           
                            
                           
                        }
                    
                    
                }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500))
            }.navigationBarTitle("")
             .navigationBarHidden(true)
            
        }
            
    }
}



