//
//  ServerInfoView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/3/22.
//

import SwiftUI

struct ServerInfoView: View {
    @ObservedObject var client: Client
    @Binding var screen: Bool
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    withAnimation(.spring()){
                        screen = false
                        client.socket.disconnect()
                    }
                    
                },label: {
                    Image(systemName: "arrowshape.turn.up.backward.circle").font(.system(size: 25, design: .rounded)).padding(.leading, 40)
                        .foregroundColor(.red)
                }).opacity(0.8)
                Spacer()
                Text(self.client.connected ? "Connected": "Disconnected").foregroundColor(self.client.connected ? .green: .red).font(.system(size: 20, design: .rounded)).padding(.horizontal)
                Image(systemName: self.client.connected ? "point.3.filled.connected.trianglepath.dotted": "point.3.connected.trianglepath.dotted")
                    .font(.system(size: 25, design: .rounded))
                    .foregroundColor(self.client.connected ? .green : .red)
                Spacer()
                    Button(action: {
                        withAnimation(.spring()){
                            self.client.connect()
                        }
                        
                    },label: {
                        Image(systemName: "arrow.clockwise").font(.system(size: 25, design: .rounded))
                            .foregroundColor(.teal).padding(.trailing, 40)
                    }).opacity(!self.client.connected ? 0.8 : 0)

        
            }
            Divider()
            if(self.client.connected){
                
            
                HStack{
                    Text("Active Players: \(self.client.connectedPlayers) ").foregroundColor(.cyan).padding(.leading).font(.system(size: 15, design: .rounded)).padding(.horizontal)
                    Spacer()
                    Text("Active Games: \(self.client.serverList.count)").foregroundColor(.cyan).padding(.trailing).font(.system(size: 15, design: .rounded)).padding(.horizontal)
                }
               
            }
            else{
                HStack{
                    Text("Disconnected from server, press button above to attempt reconnection. ").foregroundColor(.black).padding(.leading).font(.system(size: 11, design: .rounded)).padding(.horizontal)
                }
            }
            Divider()
            
        }
        
    }
}
