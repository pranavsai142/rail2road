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
        VStack {
            TextField("Full Name", text: $fullName)
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
            
            TextField("Email", text: $email)
                .padding(.leading)
                .padding(.trailing)
            
            Spacer()
            
            Button("Save", action: {
                
            })
                .padding()
        }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
