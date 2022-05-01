//
//  EditView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct EditView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                NavigationLink(
                    destination: AccountView()) {
                    Text("back")
                }
                NavigationLink(
                    destination: AccountView()) {
                    Text("save")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
