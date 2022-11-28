//
//  EditView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var name: String = ""
    @State private var email: String = ""
    
    var uid: String
    
    var userNameTag = "user_name"
    
    private func submit() {
        if(name != dataConglomerate.dataToString(tag: userNameTag)) {
            database.setValue(path: ["users", uid, "name"], value: name)
        }
    }
    
    var body: some View {
        VStack {
            TextField(dataConglomerate.dataToString(tag: userNameTag), text: $name)
            Spacer()
            Button(action: {
                submit()
            }) {
                Text("submit")
            }
        }
            .padding()
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(uid: "1")
    }
}
