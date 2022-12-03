//
//  LoginView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var tryAgainLater: Bool = false
    @State private var networkError: Bool = false
    @State private var failed: Bool = false
    @State private var uid: String = ""
    
    private func authenticate() {
        email = "best@newsies.us"
        password = "Newsies"
        failed = false
        networkError = false
        tryAgainLater = false
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if((result) != nil) {
//                print("success!")
//                print(result!.user.uid)
                uid = result!.user.uid
                isAuthenticated = true
                failed = false
            }
            else {
//                isAuthenticated = false
//                failed = true
//                print("ERROR")
//                print(error!)
                let errorCode = (error as NSError?)!.code
                if(errorCode == 17010) {
                    tryAgainLater = true
                } else if(errorCode == 17020) {
                    networkError = true
                }
                isAuthenticated = false
                failed = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rail2Road")
                    .font(.title)
                    .bold()
                TextField("Email", text: $email)
            
                SecureField("Password", text: $password)
            
                NavigationLink(
                    destination: MapView(uid: uid)
                        .environmentObject(database)
                        .environmentObject(dataConglomerate),
                    isActive: $isAuthenticated) {
                    Button(action: {
                        authenticate()
                    }) {
                        Text("Login")
                    }
                }
                if(tryAgainLater) {
                    Text("Reset passowrd or try again later")
                } else if(networkError) {
                    Text("Network error")
                } else if(failed) {
                    Text("Incorrect credentials")
                }
                
                Spacer()
                
                NavigationLink(
                    destination: ResetView()) {
                    Text("Reset Password")
                }
                NavigationLink(
                    destination: RegisterView()
                        .environmentObject(database)
                        .environmentObject(dataConglomerate)) {
                    Text("Register")
                }
            }
                .padding()
        }
            .navigationBarTitle("Rail2Road")
            .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
