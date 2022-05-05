//
//  EditView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct EditView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Full Name", text: $fullName)
                    .padding(.leading)
                    .padding(.trailing)
                
                TextField("Email", text: $email)
                    .padding(.leading)
                    .padding(.trailing)
                
                Button("Save", action: {
                    
                })
            }
                .navigationBarTitle("Edit")
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
