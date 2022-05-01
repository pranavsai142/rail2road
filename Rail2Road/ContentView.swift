//
//  ContentView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    private var query: Bool {

        return true
    }
    var body: some View {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
