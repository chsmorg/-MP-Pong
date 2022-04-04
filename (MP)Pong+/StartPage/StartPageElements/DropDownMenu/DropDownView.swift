//
//  DropDownView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import SwiftUI

struct DropDownView: View {
    @State var expand = false
    @Binding var lobbyType: Int
    @Binding var serverType: Int
    @Binding var customServer: String
    
    var body: some View{
        VStack() {
             Spacer()
            VStack(spacing: 30) {
                HStack(spacing: 1) {
                    Text (lobbyType == 1 ? "Multiplayer": "Singleplayer")
                          .fontWeight(.bold)
                          .foregroundColor(.white)
                          .frame(width: 130)
                     Image(systemName: expand ? "chevron.up" : "chevron.down")
                          .resizable()
                          .frame (width: 13, height: 6)
                          .foregroundColor(.white)
                 }.onTapGesture{
                     withAnimation(.spring()){
                          self.expand.toggle()
                     }
                     
                 }
                
                    if expand {
                        VStack{
                            GameTypeToggle(lobbyType: $lobbyType)
                            if(lobbyType == 1){
                                Text("Server Connect:").font(.system(size:13, weight: .regular, design: .rounded))
                                    .foregroundColor(Color(UIColor.lightGray))
                                withAnimation(.spring()){
                                    ServerTypeToggle(serverType: $serverType)
                                }
                                
                                if(serverType == 3){
                                    withAnimation(.spring()){
                                     CustomIP(customIP: $customServer)
                                    }
                                }
                                
                            }
                            
                        }
                        
            }
                
        }
            .padding()
            .background(RoundedRectangle(cornerRadius: 45).stroke(.secondary, style: StrokeStyle(lineWidth: 1)))
             
             .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
       }
   }
}

//

//Button(action: {
// print("2")
// self.expand.toggle()
//},label:{
// Text ("Settings")
//     .padding ()
//     .foregroundColor(.white)
//})
//Button(action: {
// print("3")
// self.expand.toggle()
//},label: {
// Text("Sign out")
//     .padding ()
//     .foregroundColor(.white)
//})
