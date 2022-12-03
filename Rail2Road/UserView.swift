//
//  AccountView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var deleteAccountAlertActive: Bool = false
    
    var uid: String
    
    var userPath: [String] {
        ["users", uid]
    }
    
    var userNameTag: String {
        "user_" + uid + "_name_tag"
    }

    var query: Bool {
        DispatchQueue.main.async {
            _ = database.getValue(path: userPath, key: "name", tag: userNameTag, dataConglomerate: dataConglomerate)
        }
        return true
    }
    
    private func deleteAccount() {
        
    }
    
    private func logout() {
        
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
                            }
                        }
                            .padding(.bottom)
                        NavigationLink(
                            destination: EmailView()
                                .environmentObject(database)
                                .environmentObject(dataConglomerate)) {
                            Text("Change Email")
                        }
                            .padding(.bottom)
                        NavigationLink(
                            destination: ResetView()
                                .environmentObject(database)
                                .environmentObject(dataConglomerate)) {
                            Text("Reset Password")
                        }
                            .padding(.bottom)
                        Button(action: {
                            deleteAccountAlertActive = true
                        }) {
                            Text("Delete Account")
                                .bold()
                                .foregroundColor(.red)
                        }
                            .padding(.top)
                            .alert(isPresented: $deleteAccountAlertActive) {
                                Alert(title: Text("Confirm Deletion"),
                                      message: Text("Are you sure you want to delete your account? This process is irreversable."),
                                      primaryButton: .cancel(),
                                      secondaryButton: .destructive(Text("Delete")) {
                                        deleteAccount()
                                      })
                            }
                    }
                    Spacer()
                    Button(action: {
                        logout()
                    }) {
                        Text("logout")
                    }
                }
                    .padding()
                    .navigationTitle("User Info")
                    .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(uid: "1")
    }
}
