//
//  ScoreCounter.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/12/22.
//

import SwiftUI

struct ScoreCounter: View{
    @ObservedObject var states: States
    
    
    var body: some View{
        HStack{
            ScoreCounterLayOut(player: states.playerList[0], rounds: states.rounds)
            Spacer()
            InGameOptions(states: states)
            Spacer()
            if(states.playerList.count > 1){
                ScoreCounterLayOut(player: states.playerList[1], rounds: states.rounds)
            }
            
            
            
           }.position(x: UIScreen.main.bounds.width/2, y: 70)
        }
}
