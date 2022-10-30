//
//  LocationManager.swift
//  Rail2Road
//
//  Created by Pranav Sai on 7/21/22.
//

import MapKit
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var region = MKCoordinateRegion()
    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    
    private let manager = CLLocationManager()
    private let searchCompleter: MKLocalSearchCompleter!
    
    private var queryCancellable: AnyCancellable?
    
    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        self.searchCompleter.delegate = self
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
        self.searchResults = completer.results.filter({ $0.subtitle == "" })
        self.status = completer.results.isEmpty ? .noResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
