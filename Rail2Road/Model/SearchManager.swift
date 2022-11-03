//
//  SearchManager.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import MapKit
import Combine
import CoreLocation

class SearchManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {

    enum SearchStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var status: SearchStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

    private let searchCompleter: MKLocalSearchCompleter!
    private var queryCancellable: AnyCancellable?

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self

        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
        self.searchResults = completer.results.filter({ $0.subtitle != "" && $0.subtitle != "Search Nearby"})
//        self.searchResults = completer.results
        self.status = completer.results.isEmpty ? .noResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
    
    func SearchStringToRegion(completion: MKLocalSearchCompletion, dataConglomerate: DataConglomerate) {
        let address: String
//        There are 3 commas in a standard postal address. If the subtitle is not a postal address, concatenate the title
        if(completion.subtitle.filter{ $0 == "," }.count < 3) {
            address = completion.title + ", " + completion.subtitle
        } else {
            address = completion.subtitle
        }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location,
                let identifier = placemarks.first?.region?.identifier
            else {
                return
            }
            
            dataConglomerate.region.center = location.coordinate
            dataConglomerate.region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            print("Identifier", identifier)
            dataConglomerate.searchOverlayActive = false
        }
    }
}
