//
//  AccountView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct AccountView: View {
    var uid: String
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    var body: some View {
        if(query) {
            VStack {
                if(dataConglomerate.data[userNameTag] != nil) {
                    Text(dataConglomerate.dataToString(tag: userNameTag))
                }
            }
                .navigationTitle("Account")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
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

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(uid: "1")
    }
}
