//
//  CustomIP.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import SwiftUI

struct CustomIP: View {
    @Binding var customIP: String
    @FocusState private var isFocused: Bool
    @State var offset: CGFloat = 0
    var body: some View {
            TextField("Custom IP:", text: $customIP).padding().background(.quaternary).cornerRadius(15).autocapitalization(.none)
            .keyboardType(.default)
                .disableAutocorrection(true)
                .foregroundColor(.white)
                .offset(x: 0, y: self.offset)
                .focused($isFocused)
                .onChange(of: isFocused) { isFocused in
                    withAnimation(.spring()){
                        if isFocused{
                            self.offset = -UIScreen.main.bounds.height/2
                        }
                        else{
                            self.offset = 0
                        }
                    }
                   
                }
    }
}


