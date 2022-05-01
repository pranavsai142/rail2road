//
//  ResetView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import Foundation

struct ResetView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Email")
                Text("Reset Password")
                NavigationLink(
                    destination: LoginView()) {
                    Text("Back")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView()
    }
}
