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
    
    @State private var submitted: Bool = false
    @State private var showingEditAlert: Bool = false
    @State private var invalidEdit: Bool = false
    @State private var name: String = ""
    @State private var email: String = ""
    
    var uid: String
    
    var userNameTag: String {
        "user_" + uid + "_name_tag"
    }
    
    private func submit() {
        if(name != dataConglomerate.dataToString(tag: userNameTag)) {
            database.setValue(path: ["users", uid, "name"], value: name)
            dataConglomerate.clearQuery(tag: userNameTag)
            submitted = true
        }
    }
    
    private func validateEdit() -> Bool {
        invalidEdit = false
        if(name != dataConglomerate.dataToString(tag: userNameTag) && name != "") {
            return true
        } else {
            invalidEdit = true
            return false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Display Name:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            TextField(dataConglomerate.dataToString(tag: userNameTag), text: $name)
            if(invalidEdit) {
                Text("Edit invalid!")
            }
            if(submitted) {
                Text("Succesfully submitted!")
            }
            Spacer()
            if(submitted) {
                Button(action: {}) {
                    Text("submit")
                        .font(.title3)
                }
                    .buttonStyle(.borderedProminent)
                    .disabled(true)
            } else {
                Button(action: {
                    if(validateEdit()) {
                        showingEditAlert = true
                    }
                }) {
                    Text("submit")
                        .font(.title3)
                }
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented: $showingEditAlert) {
                        Alert(title: Text("Review Edit"),
                              message: Text("Old Display Name: \(dataConglomerate.dataToString(tag: userNameTag))\nNew Display Name: \(name)"),
                              primaryButton: .cancel(),
                              secondaryButton: .default(Text("Submit")) {
                                submit()
                        })
                    }
            }
        }
            .padding()
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                hideKeyboard()
            }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(uid: "1")
    }
}
