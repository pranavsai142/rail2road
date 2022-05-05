//
//  RegisterView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import Foundation

struct RegisterView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Full Name", text: $fullName)
                    .padding(.leading)
                    .padding(.trailing)
                
                TextField("Email", text: $email)
                    .padding(.leading)
                    .padding(.trailing)
                SecureField("Password", text: $password)
                    .padding(.leading)
                    .padding(.trailing)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding(.leading)
                    .padding(.trailing)
                
                Spacer()
                
                NavigationLink(
                    destination: MapView()) {
                    Text("Register")
                        .padding()
                }
            }
        }
            .navigationTitle("Register")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
