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
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        }
    }
}
