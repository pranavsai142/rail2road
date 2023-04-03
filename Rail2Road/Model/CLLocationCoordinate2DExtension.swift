//
//  CLLocationCoordinate2DExtension.swift
//  Rail2Road
//
//  Created by pranav on 4/3/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Comparable, Equatable  {
    public static func < (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return ((lhs.latitude < rhs.latitude) && (lhs.longitude < rhs.longitude))
    }
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return ((lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude))
    }
    
    public static func - (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (lhs.latitude - rhs.latitude), longitude: (lhs.longitude - rhs.longitude))
    }
    
    public static func + (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (lhs.latitude + rhs.latitude), longitude: (lhs.longitude + rhs.longitude))
    }
    
    public static func coordinatesWithinBound(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D, bound: CLLocationCoordinate2D) -> Bool {
        return (absoluteValue(coordinates: (rhs - lhs)) < bound)
    }
    
    public static func absoluteValue(coordinates: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: abs(coordinates.latitude), longitude: abs(coordinates.longitude))
    }
}
