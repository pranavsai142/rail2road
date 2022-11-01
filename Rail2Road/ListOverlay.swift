//
//  ListOverlay.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import SwiftUI

struct ListOverlay: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    var uid: String
    var viewFavoriteRailyards: Bool
    
    var body: some View {
        Form {
            if(viewFavoriteRailyards) {
                Section(header: Text("Favorite Railyards")) {
                    List {
                        RailyardRow(railyard: Railyard())
                    }
                }
            } else {
                Section(header: Text("Nearby Railyards")) {
                    List {
                        ForEach(dataConglomerate.conglomerateNearbyStoredRailyards()) { railyard in
                            NavigationLink(destination: DetailView(uid: uid, railyard: railyard)
                                            .environmentObject(database)
                                            .environmentObject(dataConglomerate)) {
                                RailyardRow(railyard: railyard)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ListOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ListOverlay(uid: "1", viewFavoriteRailyards: true)
    }
}
