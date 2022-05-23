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
        database.setValue(path: ["Users", "Jackson", "Age"], value: "22")
        _ = database.getValue(path: ["Users", "Jackson"], key: "Age", tag: "JacksonAge", dataConglomerate: dataConglomerate)
        return true
    }
    
    
    var body: some View {
        LoginView()
            .environmentObject(database)
            .environmentObject(dataConglomerate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
