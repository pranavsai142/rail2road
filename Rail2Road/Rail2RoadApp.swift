//
//  Rail2RoadApp.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//

import SwiftUI
import Firebase

@main
struct Rail2RoadApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(FireDatabaseReference())
                .environmentObject(DataConglomerate())
        }
    }
}
