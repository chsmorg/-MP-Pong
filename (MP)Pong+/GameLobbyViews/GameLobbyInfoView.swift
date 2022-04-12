//
//  GameLobbyInfoView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/11/22.
//

import SwiftUI

import SwiftUI

struct GameLobbyInfoView: View {
    @ObservedObject var states: States
    @Binding var screen: Bool
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    withAnimation(.spring()){
                        screen = false
                        states.exitLobby()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                },label: {
                    Image(systemName: "arrowshape.turn.up.backward.circle").font(.system(size: 25, design: .rounded)).padding(.leading, 40)
                        .foregroundColor(.red)
                }).opacity(0.8)
                
                Text("Game Lobby: \((states.joinedGame ?? 0)+1)").foregroundColor( .green).font(.system(size: 20, design: .rounded)).padding(.horizontal)
                Spacer()
                
                    

        
            }
            Divider()
           
               
            }
        }
        
    }


