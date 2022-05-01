//
//  LoginView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import Foundation


struct LoginView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Email")
                Text("Pass")
                Text("Login")
                Text("Reset Password")
                Text("Register")
                NavigationLink(
                    destination: MapView()) {
                    Text("home")
                }
                NavigationLink(
                    destination: ResetView()) {
                    Text("reset")
                }
                NavigationLink(
                    destination: RegisterView()) {
                    Text("register")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
