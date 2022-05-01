//
//  RegisterView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import Foundation

struct RegisterView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Name")
                Text("Pass")
                Text("Email")
                Text("Register")
                NavigationLink(
                    destination: MapView()) {
                    Text("Register")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
