//
//  CustomIP.swift
//  (MP)Pong+
//
//  Created by chase morgan on 4/1/22.
//

import SwiftUI

struct CustomIP: View {
    @Binding var customIP: String
    var body: some View {
            TextField("Custom IP:", text: $customIP).padding().background(.quaternary).cornerRadius(15).autocapitalization(.none)
            .keyboardType(.default)
                .disableAutocorrection(true)
                .foregroundColor(.white)
    }
}


