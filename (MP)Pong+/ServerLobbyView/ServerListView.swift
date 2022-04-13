//
//  ServerListView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/4/22.
//

import SwiftUI


struct ServerListView: View {
    @ObservedObject var client: Client
    @ObservedObject var states: States
    @State var offset: CGFloat = -UIScreen.main.bounds.width
    @Binding var joining: Bool
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ForEach(0...self.client.serverList.count-1 ,id: \.self){ index in
                
                ServerListElement(client: client, states: states, joining: $joining, serverNum: index, connectedPayers: self.client.serverList[index], active: false).padding().offset(x: index%2 == 0 ? self.offset : -self.offset)
                    .onAppear(){
                        withAnimation(.spring().speed(0.6)){
                            self.offset = 0
                        }
                    }
                    
               
                
            }
        }
    }
}

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}

