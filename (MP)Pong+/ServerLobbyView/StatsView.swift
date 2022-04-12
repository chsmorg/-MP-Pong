//
//  StatsView.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/11/22.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var states: States
    var body: some View {
        VStack{
            Text("\(states.player.name.capitalized)'s Session Stats:").foregroundColor(.cyan).font(.system(size: 15, design: .rounded)).padding(.horizontal)
            HStack{
                Text("Wins: \(states.player.wins)").foregroundColor(.mint).font(.system(size: 15, design: .rounded)).padding(.horizontal)
                Text("Losses: \(states.player.gamesPlayed - states.player.wins)").foregroundColor(.orange).font(.system(size: 15, design: .rounded)).padding(.horizontal)
                if(states.player.gamesPlayed != 0){
                    Text("Win Rate \(String(format: "%.2f" ,Double(states.player.wins)/Double(states.player.gamesPlayed)*100))%").foregroundColor(.cyan).font(.system(size: 15, design: .rounded)).padding(.horizontal)
                }
                
            }
        }
        
    }
}
