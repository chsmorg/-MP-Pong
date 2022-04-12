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
    @State var postion1 = CGPoint(x: UIScreen.main.bounds.width/2 - UIScreen.main.bounds.width/11, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height/3.8)
    @State var postion2 = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - UIScreen.main.bounds.height/8)
    
    var body: some View{
        VStack() {
            VStack() {
                VStack(spacing: 1){
                    Image(systemName: expand ? "gearshape.2.fill" : "gearshape.2")
                        
                        .frame (width: 20, height: 20)
                        .foregroundColor(.white)
                }.onTapGesture {
                    withAnimation(.spring()){
                      self.expand.toggle()
                    }
                }
                if expand{
                    VStack{
                        HStack{
                            
                        }
                    }//.frame(width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height/8)
                }
                
                     
                
                
        }.padding()
         .background(RoundedRectangle(cornerRadius: 45).stroke(.secondary, style: StrokeStyle(lineWidth: 1)))
         .position(self.expand ? postion2 : postion1)
       }
   }
}


//HStack(spacing: 1) {
//    Text (lobbyType == 1 ? "Multiplayer": "Singleplayer")
//          .fontWeight(.bold)
//          .foregroundColor(.white)
//          .frame(width: 130)
//     Image(systemName: expand ? "chevron.up" : "chevron.down")
//          .resizable()
//          .frame (width: 13, height: 6)
//          .foregroundColor(.white)
// }.onTapGesture{
//     withAnimation(.spring()){
//          self.expand.toggle()
//     }
//
// }
//
//    if expand {
//        VStack{
//            GameTypeToggle(lobbyType: $lobbyType)
//            if(lobbyType == 1){
//                Text("Server Connect:").font(.system(size:13, weight: .regular, design: .rounded))
//                    .foregroundColor(Color(UIColor.lightGray))
//                withAnimation(.spring()){
//                    ServerTypeToggle(serverType: $serverType)
//                }
//
//                if(serverType == 3){
//                    withAnimation(.spring()){
//                     CustomIP(customIP: $customServer)
//                    }
//                }
//
//            }
//
//        }
//
//}
