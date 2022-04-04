//
//  GameTypeToggle.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import SwiftUI

struct GameTypeToggle: View {
    @Binding var lobbyType: Int
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 45).stroke(.secondary, style: StrokeStyle(lineWidth: 1)).frame(width: 200, height: 29.9).shadow(radius: 20)
            HStack{
                
                
                Text("Multiplayer").padding()
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(lobbyType == 1 ? .pink : .cyan)
                    .background(RoundedRectangle(cornerRadius: 45).frame(width: 88, height: 29)
                        .foregroundColor(.secondary).opacity(lobbyType == 1 ? 0.8 : 0))
                    .opacity(0.9)
                    .onTapGesture{
                        withAnimation(.spring()){
                            lobbyType = 1
                        }
                }
                Text("Singleplayer").padding()
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(lobbyType == 2 ? .pink : .cyan)
                    .opacity(0.9)
                    .background(RoundedRectangle(cornerRadius: 45).frame(width: 94, height: 29)
                        .foregroundColor(.secondary).opacity(lobbyType == 2 ? 0.8 : 0))
                    .onTapGesture{
                        withAnimation(.spring()){
                            lobbyType = 2
                        }
                }
            }
        }
        
    }
}

