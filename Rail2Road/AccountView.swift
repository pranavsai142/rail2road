//
//  AccountView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    var uid: String
    
    var userNameTag = "user_name"
    
    var userPath: [String] {
        ["users", uid]
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
            VStack {
                if(dataConglomerate.queries[userNameTag] == DataConglomerate.QueryStatus.result) {
                    HStack {
                        Text("Name: \(dataConglomerate.dataToString(tag: userNameTag))")
                        Spacer()
                        NavigationLink(
                            destination: EditView(uid: uid)
                                .environmentObject(database)
                                .environmentObject(dataConglomerate)) {
                            Image(systemName: "pencil.circle.fill")
                        }
                    }
                    HStack {
                        Text("Email: test@test.com")
                        Spacer()
                    }
                    Button(action: {
                        deleteAccount()
                    }) {
                        Text("Delete Account")
                            .bold()
                            .foregroundColor(.red)
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
                .navigationTitle("Account")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(uid: "1")
    }
}
