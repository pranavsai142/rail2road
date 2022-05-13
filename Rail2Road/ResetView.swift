//
//  ResetView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import Foundation

struct ResetView: View {
    @State private var email: String = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding(.leading)
                .padding(.trailing)
            
            Button("Reset Password", action: {})
                .padding()
            
            Spacer()
            
            Text("Email Sent!")
                .padding()
        }
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView()
    }
}
