//
//  AccountView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct AccountView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    var body: some View {
        VStack {
            Text("Full Name")
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
            
            Text("Email")
                .padding(.leading)
                .padding(.trailing)

            Spacer()
            
            NavigationLink(
                destination: EditView()) {
                Text("Edit")
                    .padding()
            }
        }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
