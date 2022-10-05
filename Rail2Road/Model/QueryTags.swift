//
//  QueryTags.swift
//  Rail2Road
//
//  Created by pranav sai on 8/18/22.
//

protocol QueryTags: Hashable {

}

struct StringQueryTags: QueryTags {
    var tag: String
    var foundTag: String
    
    init(tag: String, foundTag: String) {
        self.tag = tag
        self.foundTag = foundTag
    }
}

struct RailroadRegionQueryTags: QueryTags {
    var latitudeRegion: Int
    var longitudeRegion: Int
    
    //String to tag not tested
    init(tag: String, foundTag: String) {
        let coordinates = tag.suffix(tag.count - 13)
        let index = coordinates.firstIndex(of: "_")!
        let latitude = coordinates.prefix(upTo: index)
        let longitude = coordinates.suffix(coordinates.count - latitude.count)
        self.latitudeRegion = Int(latitude)!
        self.longitudeRegion = Int(longitude)!
    }
    
    init(latitudeRegion: Int, longitudeRegion: Int) {
        self.latitudeRegion = latitudeRegion
        self.longitudeRegion = longitudeRegion
    }
    
    func getTopBound() -> Int {
        return latitudeRegion
    }
    
    func getBottomBound() -> Int {
        return latitudeRegion - 2
    }
    
    func getLeftBound() -> Int {
        return longitudeRegion
    }
    
    func getRightBound() -> Int {
        return longitudeRegion + 2
    }
    
    func getLatLongMinBound() -> String {
        return String(getBottomBound()) + "_" + String(getRightBound())
    }
    
    func getLatLongMaxBound() -> String {
        return String(getTopBound()) + "_" + String(getLeftBound())
    }
}
