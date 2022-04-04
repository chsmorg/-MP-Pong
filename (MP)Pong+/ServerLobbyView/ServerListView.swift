//
//  ServerListView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/4/22.
//

import SwiftUI


struct ServerListView: View {
    @ObservedObject var client: Client
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ForEach(0...self.client.serverList.count-1 ,id: \.self){ index in
                withAnimation(.easeIn(duration: 0.1)){
                    ServerListElement(serverNum: index, connectedPayers: self.client.serverList[index], active: false).padding()
                }
                
            }
        }
    }
}

