//
//  ListOverlay.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import SwiftUI

struct ListOverlay: View {
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
                        RailyardRow(railyard: Railyard())
                    }
                }
            }
        }
    }
}

struct ListOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ListOverlay(viewFavoriteRailyards: true)
    }
}
