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
    
    private func refresh() async {
        try! await Task.sleep(nanoseconds: 500000000)
        dataConglomerate.clearWaittimeData()
        dataConglomerate.clearWaittimeQueries()
    }
    
    var body: some View {
        VStack {
            HStack {
                if(viewFavoriteRailyards) {
                    Text("Favorite Railyards")
                        .font(.subheadline)
                        .bold()
                } else {
                    Text("Nearby Railyards")
                        .font(.subheadline)
                        .bold()
                }
                Spacer()
            }
                .padding(.top)
                .padding(.leading)
            Divider()
            //Courtesy of jstarry95
            RefreshableScrollView(showsIndicators: true) {
                if(viewFavoriteRailyards) {
                    ForEach(dataConglomerate.favoriteRailyards) { railyard in
                        NavigationLink(destination: DetailView(uid: uid, railyard: railyard)
                            .environmentObject(database)
                            .environmentObject(dataConglomerate)) {
                                RailyardRow(railyard: railyard, averageWaittimeMinutes: dataConglomerate.waittimeToMinutes(railyardId: railyard.id))
                            }
                    }
                } else {
                    ForEach(dataConglomerate.conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 99, railyardsDisplayedModOperator: 1, boundDimension: 0)) { railyard in
                        NavigationLink(destination: DetailView(uid: uid, railyard: railyard)
                            .environmentObject(database)
                            .environmentObject(dataConglomerate)) {
                                RailyardRow(railyard: railyard, averageWaittimeMinutes: dataConglomerate.waittimeToMinutes(railyardId: railyard.id))
                        }
                    }
                }
            } onRefresh: {
                await refresh()
            }
        }
    }
}

struct ListOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ListOverlay(uid: "1", viewFavoriteRailyards: true)
    }
}
