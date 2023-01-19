//
//  ResetView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import FirebaseAuth

struct ResetView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    @State private var email = ""
    @State private var isSent = false
    @State private var failed = false
    @State private var invalidUser = false
    @State private var networkError = false
    
    private func reset() {
        isSent = false
        failed = false
        invalidUser = false
        networkError = false
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if((error) != nil) {
                let errorCode = (error as NSError?)!.code
                if(errorCode == 17011) {
                    invalidUser = true
                } else if(errorCode == 17020) {
                    networkError = true
                }
                isSent = false
                failed = true
            }
            else {
                isSent = true
                failed = false
            }
        })
    }
    
    var body: some View {
        VStack {
//            Text("Reset Password")
//                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            TextField("email", text: $email)
            Button(action: {
                reset();
            }) {
                Text("Reset")
            }
            if(isSent) {
                Text("Sent!")
            } else if(invalidUser) {
                Text("Account not found")
            } else if(networkError) {
                Text("Network error")
            } else if(failed) {
                Text("Please enter valid email")
            }
            Spacer()
        }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView()
    }
}
