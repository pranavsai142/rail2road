//
//  MapView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Map")
                NavigationLink(
                    destination: DetailView()) {
                    Text("Detail")
                }
                NavigationLink(
                    destination: AccountView()) {
                    Text("account")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
