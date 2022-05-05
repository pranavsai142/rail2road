//
//  LoginView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import Foundation


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rail2Road")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                
                Spacer()
            
                TextField("Email", text: $email)
                    .padding(.leading)
                    .padding(.trailing)
            
                SecureField("Password", text: $password)
                    .padding(.leading)
                    .padding(.trailing)
            
                NavigationLink(
                    destination: MapView()) {
                    Text("Login")
                        .padding()
                }
                
                Spacer()
                
                NavigationLink(
                    destination: ResetView()) {
                    Text("Reset Password")
                        .padding(.bottom, 1)
                }
                NavigationLink(
                    destination: RegisterView()) {
                    Text("Register")
                        .padding(.bottom)
                }
            }
        }
            .navigationTitle("Rail2Road")
            .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
