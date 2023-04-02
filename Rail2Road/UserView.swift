//
//  AccountView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import FirebaseAuth

struct UserView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var deleteAccountAlertActive: Bool = false
    @State private var logoutAlertActive: Bool = false
    
    var uid: String
    
    var userPath: [String] {
        ["users", uid]
    }
    
    var userNameTag: String {
        "user_" + uid + "_name_tag"
    }

    var query: Bool {
//        DispatchQueue.main.async {
        _ = database.getValue(path: userPath, key: "name", tag: userNameTag, dataConglomerate: dataConglomerate)
//        }
        return true
    }
    
    private func deleteAccount() {
        database.removeValue(path: ["users", uid])
        Auth.auth().currentUser!.delete()
        logout()
    }
    
    ///Exits application
    private func logout() {
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            exit(0)
        }
    }
    
    var body: some View {
        if(query) {
            ZStack {
                VStack {
                    if(dataConglomerate.queries[userNameTag] == DataConglomerate.QueryStatus.result) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Display Name:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(dataConglomerate.dataToString(tag: userNameTag))
                                
                            }
                            Spacer()
                            NavigationLink(
                                destination: EditView(uid: uid)
                                    .environmentObject(database)
                                    .environmentObject(dataConglomerate)) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title3)
                            }
                        }
                            .padding(.bottom)
                        NavigationLink(
                            destination: EmailView()
                                .environmentObject(database)
                                .environmentObject(dataConglomerate)) {
                            Text("Change Email")
                                .font(.title3)
                        }
                            .buttonStyle(.bordered)
                            .padding(.bottom)
                        NavigationLink(
                            destination: ResetView()
                                .environmentObject(database)
                                .environmentObject(dataConglomerate)) {
                            Text("Reset Password")
                                .font(.title3)
                        }
                            .buttonStyle(.bordered)
                            .padding(.bottom)
                        Button(action: {
                            deleteAccountAlertActive = true
                        }) {
                            Text("Delete Account")
                                .bold()
                                .font(.title3)
                                .foregroundColor(.red)
                        }
                            .buttonStyle(.bordered)
                            .padding(.top)
                            .alert(isPresented: $deleteAccountAlertActive) {
                                Alert(title: Text("Confirm Deletion"),
                                      message: Text("Are you sure you want to delete your account? Rail2Road will quit upon successful deletion."),
                                      primaryButton: .cancel(),
                                      secondaryButton: .destructive(Text("Delete")) {
                                        deleteAccount()
                                      })
                            }
                    }
                    Spacer()
                    Button(action: {
                        logoutAlertActive = true
                    }) {
                        Text("logout")
                            .font(.title3)
                    }
                        .buttonStyle(.borderedProminent)
                        .alert(isPresented: $logoutAlertActive) {
                            Alert(title: Text("Exiting App"),
                                  message: Text("Please relaunch Rail2Road and reauthenticate!"),
                                  primaryButton: .cancel(),
                                  secondaryButton: .default(Text("Exit")) {
                                    logout()
                                  })
                        }
                }
                    .padding()
                    .navigationTitle("User Info")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        hideKeyboard()
                    }
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(uid: "1")
    }
}
