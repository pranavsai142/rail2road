//
//  Railyard.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/5/22.
//

import Foundation
import SwiftUI
import MapKit

struct Railyard: Identifiable, Comparable, Equatable {
    static func < (lhs: Railyard, rhs: Railyard) -> Bool {
        return lhs.coordinates.latitude < rhs.coordinates.latitude
    }
    
    static func == (lhs: Railyard, rhs: Railyard) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func waittimeToColor(waittime: String) -> Color {
        if(waittime == "-"){
            return Color.gray
        }
        
        let waittimeInt: Int = Int(waittime)!
        
        if(waittimeInt <= 30) {
            return Color.green
        } else if(waittimeInt <= 60) {
            return Color.yellow
        } else {
            return Color.red
        }
    }
    
    let id: UUID
    let coordinates: CLLocationCoordinate2D
    let name: String
    let address: String
//    init(id: UUID = UUID(), coordinates: CLLocationCoordinate2D) {
//        self.id = id
//        self.coordinates = coordinates
//        self.name = "fda"
//        self.waittime = TimeInterval()
//        self.address = "f39"
//    }
    init(id: UUID, dictionary: NSDictionary) {
        self.id = id
        self.coordinates = CLLocationCoordinate2D(latitude: dictionary.value(forKey: "latitude") as! CLLocationDegrees, longitude: dictionary.value(forKey: "longitude") as! CLLocationDegrees)
        self.name = dictionary.value(forKey: "name") as! String
        self.address = dictionary.value(forKey: "address") as! String
    }
    init() {
        self.id = UUID()
        coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.name = ""
        self.address = ""
    }
}
