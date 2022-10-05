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
    let name: String
    let waittime: Int = 10
    init(id: UUID = UUID(), coordinates: CLLocationCoordinate2D) {
        self.id = id
        self.coordinates = coordinates
        self.name = "fda"
    }
    init(id: UUID, dictionary: NSDictionary) {
        self.id = id
        self.coordinates = CLLocationCoordinate2D(latitude: dictionary.value(forKey: "latitude") as! CLLocationDegrees, longitude: dictionary.value(forKey: "longitude") as! CLLocationDegrees)
        self.name = dictionary.value(forKey: "name")  as! String
    }
    init() {
        self.id = UUID()
        coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.name = "nafd"
    }
}
