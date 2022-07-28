//
//  Railyard.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/5/22.
//

import MapKit

struct Railyard: Identifiable {
    let id: UUID
    let coordinates: CLLocationCoordinate2D
    let title: String = "Test Railyard"
    let waittime: Int = 10
    init(id: UUID = UUID(), coordinates: CLLocationCoordinate2D) {
        self.id = id
        self.coordinates = coordinates
    }
    init() {
        self.id = UUID()
        coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
