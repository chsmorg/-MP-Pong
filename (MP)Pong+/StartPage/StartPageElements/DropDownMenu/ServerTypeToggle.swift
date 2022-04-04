//
//  ServerTypeToggle.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import SwiftUI


struct ServerTypeToggle: View {
    @Binding var serverType: Int
    @State var selected: Int = 1
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 45).stroke(.secondary, style: StrokeStyle(lineWidth: 1)).frame(width: 250, height: 29.9).shadow(radius: 20)
            VStack{
                HStack{
                    
                    
                    Text("Defualt").padding()
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(serverType == 1 ? .pink : .cyan)
                        .background(RoundedRectangle(cornerRadius: 45).frame(width: 84, height: 29)
                            .foregroundColor(.secondary).opacity(serverType == 1 ? 0.8 : 0))
                        .opacity(0.9)
                        .onTapGesture{
                            withAnimation(.spring()){
                                serverType = 1
                            }
                    }
                    Text("Hosted").padding()
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(serverType == 2 ? .pink : .cyan)
                        .opacity(0.9)
                        .background(RoundedRectangle(cornerRadius: 45).frame(width: 94, height: 29)
                            .foregroundColor(.secondary).opacity(serverType == 2 ? 0.8 : 0))
                        .onTapGesture{
                            withAnimation(.spring()){
                                serverType = 2
                            }
                            
                    
                    }
                    Text("Custom").padding()
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(serverType == 3 ? .pink : .cyan)
                        .opacity(0.9)
                        .background(RoundedRectangle(cornerRadius: 45).frame(width: 85, height: 29)
                            .foregroundColor(.secondary).opacity(serverType == 3 ? 0.8 : 0))
                        .onTapGesture{
                            withAnimation(.spring()){
                                serverType = 3
                            }
                    }
                    
                    
                }
                
            }
            
        }
        
    }
}
