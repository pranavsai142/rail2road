//
//  Railyard.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/5/22.
//

import Foundation
import MapKit

struct Railyard: Identifiable {
    let id: UUID
    let coordinates: CLLocationCoordinate2D
    let title: String = "Hii"
    init(id: UUID = UUID(), coordinates: CLLocationCoordinate2D) {
        self.id = id
        self.coordinates = coordinates
    }
}
