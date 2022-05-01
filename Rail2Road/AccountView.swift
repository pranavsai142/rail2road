//
//  AccountView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("email")
                Text("full name")
                Text("reset password")
                NavigationLink(
                    destination: ResetView()) {
                    Text("reset")
                }
                NavigationLink(
                    destination: MapView()) {
                    Text("back")
                }
                NavigationLink(
                    destination: EditView()) {
                    Text("edit")
                }
                NavigationLink(
                    destination: LoginView()) {
                    Text("sign out")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
