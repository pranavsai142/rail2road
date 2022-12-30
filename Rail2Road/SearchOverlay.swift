//
//  SearchOverlay.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import SwiftUI
import MapKit

struct SearchOverlay: View {
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @StateObject var searchManager = SearchManager()
    
    private func updateMapRegion(completion: MKLocalSearchCompletion) {
        searchManager.SearchStringToRegion(completion: completion, dataConglomerate: dataConglomerate)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Location Search")) {
                ZStack(alignment: .trailing) {
                    TextField("Search", text: $searchManager.queryFragment)
                    // This is optional and simply displays an icon during an active search
                    if searchManager.status == .searching {
                        Image(systemName: "clock")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            Section(header: Text("Results")) {
                List {
                    switch searchManager.status {
                        case .empty: Text("No Results")
                        case .error(let description): Text("Error: \(description)")
                        default: EmptyView()
                    }

                    ForEach(searchManager.searchResults, id: \.self) { completion in
                        // This simply lists the results, use a button in case you'd like to perform an action
                        // or use a NavigationLink to move to the next view upon selection.
                            Button(action: {
                                updateMapRegion(completion: completion)
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(completion.title)
                                    Text(completion.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            })
                    }
                }
            }
        }
    }
}

struct SearchOverlay_Previews: PreviewProvider {
    static var previews: some View {
        SearchOverlay()
    }
}
