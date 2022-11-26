//
//  DataConglomerate.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//
import MapKit
import Foundation

/// Conglomerates and stores data for the operations of the app.
final class DataConglomerate: ObservableObject {
    
    enum QueryStatus: Equatable {
        case searching
        case empty
        case error
        case result
    }

    /// data dictionary. Use for local storage of metadata like information
    @Published var data: [String: Any] = [String: Any]()
    /// query dictionary. Used for keeping track of the status of queries
    @Published var queries: [String: QueryStatus] = [String: QueryStatus]()
    /// dictionary containing locally saved railyard regions, key of the dictionary being a RailyardRegionQueryTag
//    @Published var storedUserRailyardRegions: [RailroadRegionQueryTags: RailyardRegion] = [RailroadRegionQueryTags: RailyardRegion]()
    
    @Published var storedUserLongitudeRegions: [Int: [Railyard]] = [Int: [Railyard]]()
    @Published var favoriteRailyards: [Railyard] = [Railyard]()
    
    /// Dictionary storing average waittimes associated with a given railyard. Key is railyard uuid.
    @Published var storedAverageWaittimes: [UUID: TimeInterval] = [UUID: TimeInterval]()
    /// Dictionary storing waittime objects associated with a given railyard. key is railyard uuid.
    /// TODO: Determine if individual waittimes need to be stored
    @Published var storedWaittimes: [UUID: [Waittime]] = [UUID: [Waittime]]()
    
    /// Boolean that detirmines if the SearchOverlay is visible or not.
    /// The reason for having this variable stored in DataConglomerate is because the value has to persist between two views, MapView and SearchOverlay.
    @Published var searchOverlayActive: Bool = false
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
    
    func dataToString(tag: String) -> String {
        return data[tag] as! String
    }
    
    func conglomerateNearbyStoredRailyards() -> [Railyard] {
        let userLongitudeRegionsTags = findLongitudeRegionsTags()
        var storedNearbyRailyards: [Railyard] = []
        for userLongitudeRegionTags in userLongitudeRegionsTags {
            if storedUserLongitudeRegions[userLongitudeRegionTags.longitudeRegion] != nil {
                for railyard in storedUserLongitudeRegions[userLongitudeRegionTags.longitudeRegion]! {
                    if(abs(railyard.coordinates.latitude - region.center.latitude) < 2.0) {
                        storedNearbyRailyards.append(railyard)
                    }
                }
            }
        }
        return storedNearbyRailyards
    }
    
    /// Conglomerates all railyards stored in DataConglomerate storedUserLongitudeRegions dictionary and favoriteRailyards list
    /// - Returns: Returns an array of railyards currently in data conglomerate memory
    func conglomerateAllStoredRailyards() -> [Railyard] {
        var railyards: [Railyard] = []
        for regionRailyards in storedUserLongitudeRegions.values {
            railyards.append(contentsOf: regionRailyards)
        }
        for railyard in favoriteRailyards {
            railyards.append(railyard)
        }
        return railyards
    }
    
    /// Conglomerates railyards stored in DataConglomerate storedUserLongitudeRegions dictionary
    /// - Returns: returns array of Railyard objects, values of storedUserLongitudeRegions
    func conglomerateRegionalStoredRailyards() -> [Railyard] {
        var railyards: [Railyard] = []
        for regionRailyards in storedUserLongitudeRegions.values {
            railyards.append(contentsOf: regionRailyards)
        }
        return railyards
    }
    
    
    /// Function to return a string representation of the average waittime for a given railyard.
    /// The waittime is found by acceessing stored average waittimes
    /// - Parameter railyardId: railyard to return string waittime of
    /// - Returns: waittime in minutes. Returns hyphen if no average waittime recorded.
    func waittimeToMinutes(railyardId: UUID) -> String {
        let waittimeAverage = storedAverageWaittimes[railyardId]
        if(waittimeAverage == nil) {
            return "-"
        } else {
            return waittimeAverage!.toMinutesString()
        }
    }
    
    func clearWaittimeData() {
        storedAverageWaittimes = [UUID: TimeInterval]()
        storedWaittimes = [UUID: [Waittime]]()
    }
    
    func getChatHistory(railyard: Railyard) -> [Chat] {
        var chatHistory: [Chat] = []
        chatHistory.append(Chat(message: "Quick, fast service"))
        chatHistory.append(Chat(message: "Just left this depot. moving fast now."))
        chatHistory.append(Chat(message: "Where are some good lodges around here?"))
        chatHistory.append(Chat(message: "Quick, fast service"))
        chatHistory.append(Chat(message: "Just left this depot. moving fast now."))
        chatHistory.append(Chat(message: "Where are some good lodges around here?"))
        chatHistory.append(Chat(message: "Quick, fast service"))
        chatHistory.append(Chat(message: "Just left this depot. moving fast now."))
        chatHistory.append(Chat(message: "Where are some good lodges around here?"))
        return chatHistory
    }
    
    func findLongitudeRegionsTags() -> [LongitudeRegionQueryTags] {
        var latitudeRegions: [Int] = []
        let bottomBound = region.center.latitude - (region.span.latitudeDelta/2.0)
        let topBound = region.center.latitude + (region.span.latitudeDelta/2.0)
        
        latitudeRegions.append(contentsOf: splitIntoLatitudeRegions(bottomBound: bottomBound, topBound: topBound))
        
        var longitudeRegions: [Int] = []
        var leftBound = region.center.longitude - (region.span.longitudeDelta/2.0)
        var rightBound = region.center.longitude + (region.span.longitudeDelta/2.0)
        
        if (leftBound < -180.0) {
            longitudeRegions.append(contentsOf: splitIntoLongitudeRegions(leftBound: leftBound + 360, rightBound: 180.0))
            leftBound = -180.0
        } else if (rightBound > 180.0) {
            longitudeRegions.append(contentsOf: splitIntoLongitudeRegions(leftBound: -180.0, rightBound: rightBound - 360.0))
            rightBound = 180.0
        }
        longitudeRegions.append(contentsOf: splitIntoLongitudeRegions(leftBound: leftBound, rightBound: rightBound))

        var queryTags: [LongitudeRegionQueryTags] = []
        for longitudeRegion in longitudeRegions {
            queryTags.append(LongitudeRegionQueryTags(longitudeRegion: longitudeRegion))
        }
        return queryTags
    }
    
    private func splitIntoLongitudeRegions(leftBound: CLLocationDegrees, rightBound: CLLocationDegrees) -> [Int] {
        var minLongitude = Int(floor(leftBound / 2.0)) * 2
        let maxLongitude = Int(ceil(rightBound / 2.0)) * 2
        var longitudeRegions: [Int] = []
        while (minLongitude <= maxLongitude && minLongitude < 180) {
            longitudeRegions.append(minLongitude)
            minLongitude = minLongitude + 2
        }
        return longitudeRegions
    }
    
    private func splitIntoLatitudeRegions(bottomBound: CLLocationDegrees, topBound: CLLocationDegrees) -> [Int] {
        var minLatitude = Int(floor(bottomBound / 2.0)) * 2
        let maxLatitude = Int(ceil(topBound / 2.0)) * 2
        var latitudeRegions: [Int] = []
        if (minLatitude <= -90) {
            minLatitude = -88
        }
        while (minLatitude <= maxLatitude && minLatitude <= 90) {
            latitudeRegions.append(minLatitude)
            minLatitude = minLatitude + 2
        }
        return latitudeRegions
    }
}

