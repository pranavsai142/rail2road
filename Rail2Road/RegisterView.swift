//
//  RegisterView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var isRegistered: Bool = false
    @State private var failedToRegister: Bool = false
    @State private var unmatchedPasswords: Bool = false
    @State private var weakEmail: Bool = false
    @State private var weakPassword: Bool = false
    @State private var emailExists: Bool = false
    @State private var showingAlert: Bool = false
    @State private var networkError: Bool = false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var reenteredPassword: String = ""
    @State private var uid: String = ""
    
    private func register() {
        failedToRegister = false
        weakEmail = false
        weakPassword = false
        emailExists = false
        networkError = false
        if (password == reenteredPassword) {
            unmatchedPasswords = false
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if((result) != nil) {
//                    print("Registered")
                    isRegistered = true
                    failedToRegister = false
                    uid = result!.user.uid
//                    print(uid)
                    database.setValue(path: ["users", uid, "name"], value: name)
                    
//                    Clear text fields
                    name = ""
                    email = ""
                    password = ""
                    reenteredPassword = ""
                }
                else {
                    print(error!)
                    let errorCode = (error as NSError?)!.code
                    if(errorCode == 17007) {
                        emailExists = true
                    } else if(errorCode == 17008) {
                        weakEmail = true
                    } else if(errorCode == 17026) {
                        weakPassword = true
                    } else if(errorCode == 17020) {
                        networkError = true
                    }
                    failedToRegister = true
                }
            })
        }
        else {
            unmatchedPasswords = true
            failedToRegister = true
        }
    }
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.title)
            TextField("perferred name", text: $name)
            TextField("email", text: $email)
            SecureField("password", text: $password)
            SecureField("reenter password", text: $reenteredPassword)
            HStack {
                Spacer()
                if(unmatchedPasswords && !isRegistered) {
                    Text("Passwords do not match")
                } else if(emailExists) {
                  Text("Email already in use")
                } else if(weakEmail) {
                    Text("Weak email")
                } else if(weakPassword) {
                    Text("Weak password")
                } else if(networkError) {
                    Text("Network error")
                } else if(failedToRegister) {
                    Text("Error in registration")
                }
                Spacer()
            }
            Spacer()
            NavigationLink(
                destination: MapView(uid: uid),
                isActive: $isRegistered) {
                Button(action: {
                    showingAlert = true
                }) {
                    Text("Register")
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("EULA"),
                      message: Text("Please review and accept the EULA to join the Rail2Road network at www.rail2road.us/eula.html"),
                      primaryButton: .cancel(),
                      secondaryButton: .default(Text("Accept")) {
                        register()
                      })
            }
        }
        .padding()
        .navigationTitle(Text("Register"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            hideKeyboard()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
