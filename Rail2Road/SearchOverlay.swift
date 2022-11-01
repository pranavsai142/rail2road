//
//  SearchOverlay.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import SwiftUI

struct SearchOverlay: View {
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @StateObject var searchManager = SearchManager()
    
    var body: some View {
        Form {
            Section(header: Text("Location Search")) {
                ZStack(alignment: .trailing) {
                    TextField("Search", text: $searchManager.queryFragment)
                    // This is optional and simply displays an icon during an active search
                    if searchManager.status == .isSearching {
                        Image(systemName: "clock")
                            .foregroundColor(Color.gray)
                    }
                }
            }
            Section(header: Text("Results")) {
                List {
                    HStack {
                        switch searchManager.status {
                            case .noResults: Text("No Results")
                            case .error(let description): Text("Error: \(description)")
                            default: EmptyView()
                        }
                    }
                        .foregroundColor(Color.gray)

                    ForEach(searchManager.searchResults, id: \.self) { completionResult in
                        // This simply lists the results, use a button in case you'd like to perform an action
                        // or use a NavigationLink to move to the next view upon selection.
                        Text(completionResult.title)
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
