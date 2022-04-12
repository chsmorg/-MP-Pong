//
//  DropDownServerView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI
struct DropDownServerView: View {
    @State var expand = false
    @Binding var lobbyType: Int
    @Binding var serverType: Int
    @Binding var customServer: String
    @State var postion1 = CGPoint(x: UIScreen.main.bounds.width/2 + UIScreen.main.bounds.width/11, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/3.8)
    @State var postion2 = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 + UIScreen.main.bounds.height/11.5)
    
    var body: some View{
        VStack() {
            VStack() {
                VStack(spacing: 1){
                    Image(systemName: expand ? "externaldrive.fill.badge.wifi" : "externaldrive.badge.wifi")
                        
                        .frame (width: 20, height: 20)
                        .foregroundColor(.white)
                }.onTapGesture {
                    withAnimation(.spring()){
                      self.expand.toggle()
                    }
                }
                if expand{
                    VStack{
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
                
                     
                
                
        }.padding()
         .background(RoundedRectangle(cornerRadius: 45).stroke(.secondary, style: StrokeStyle(lineWidth: 1)))
         .position(self.expand ? postion2 : postion1)
       }
   }
}
