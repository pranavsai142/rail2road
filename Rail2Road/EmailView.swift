//
//  EmailOverlay.swift
//  Rail2Road
//
//  Created by pranav sai on 11/30/22.
//

import SwiftUI
import FirebaseAuth

struct EmailView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var currentEmail: String = ""
    @State private var password: String = ""
    @State private var newEmail: String = ""
    @State private var newEmailConfirmation: String = ""
    @State private var authenticationAttempted: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var tryAgainLater: Bool = false
    @State private var networkError: Bool = false
    @State private var failed: Bool = false
    @State private var showingEditAlert: Bool = false
    @State private var isRegistered: Bool = false
    @State private var failedToRegister: Bool = false
    @State private var unmatchedPasswords: Bool = false
    @State private var weakEmail: Bool = false
    @State private var weakPassword: Bool = false
    @State private var emailExists: Bool = false
    @State private var uid: String = ""
    
    var userNameTag: String {
        "user_" + uid + "_name_tag"
    }

    
    private func changeEmail() {
        if(validateEdit()) {
            register()
        }
    }
    
    private func emailEntered() -> Bool {
        if(newEmail.count > 0 && newEmailConfirmation.count > 0) {
            return true
        } else {
            return false
        }
    }
    
    private func validateEdit() -> Bool {
        if(isAuthenticated && newEmail == newEmailConfirmation && emailEntered()) {
            return true
        } else {
            return false
        }
    }
    
    private func register() {
        failedToRegister = false
        weakEmail = false
        weakPassword = false
        emailExists = false
        networkError = false

        Auth.auth().createUser(withEmail: newEmail, password: password, completion: { (result, error) in
            if((result) != nil) {
//                    print("Registered")
                isRegistered = true
                failedToRegister = false
                let newUid = result!.user.uid
//                    print(uid)
                database.setValue(path: ["users", newUid, "name"], value: dataConglomerate.dataToString(tag: userNameTag))
                _ = database.copyTree(sourcePath: ["users", uid, "favorites"], destinationPath: ["users", newUid, "favorites"])
                
//                    Clear text fields
                newEmail = ""
                newEmailConfirmation = ""
                
//                assign new user id generated by FirebaseAuth to class instance variable uid
                uid = newUid
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
    
    private func authenticate() {
        authenticationAttempted = true
        failed = false
        networkError = false
        tryAgainLater = false
        Auth.auth().signIn(withEmail: currentEmail, password: password) { (result, error) in
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
        VStack {
            if(!isAuthenticated) {
                Text("Please login first!")
                    .font(.subheadline)
                    .italic()
                    .padding()
                HStack {
                    Text("Current Email:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField("Current Email", text: $currentEmail)
                HStack {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                SecureField("Password", text: $password)
                Button(action: {
                    authenticate()
                }) {
                    Text("Login")
                }
                if(tryAgainLater) {
                    Text("Reset passowrd or try again later")
                } else if(networkError) {
                    Text("Network error")
                } else if(failed) {
                    Text("Incorrect credentials")
                }
            }
            else if(authenticationAttempted && isAuthenticated) {
                HStack {
                    Text("New Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField("New Email", text: $newEmail)
                HStack {
                    Text("Confirm Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField("Confirm Email", text: $newEmailConfirmation)
                if(validateEdit()) {
                    Button(action: {
                            showingEditAlert = true
                        }, label: {
                            Text("submit")
                        })
                            .alert(isPresented: $showingEditAlert) {
                                Alert(title: Text("Review Edit"),
                                      message: Text("Current Email \(currentEmail)\nNew Email: \(newEmail)"),
                                      primaryButton: .cancel(),
                                      secondaryButton: .default(Text("Submit")) {
                                        changeEmail()
                                })
                            }
                } else {
                    Button(action: {}, label: {
                            Text("submit")
                        })
                        .disabled(true)
                    if(emailEntered()) {
                        Text("Emails don't match!")
                    }
                }
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
            }
            Spacer()
        }
            .navigationBarTitle("Change Email")
            .padding()
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
    }
}
