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
    
    @Published var storedChats: [UUID: [Chat]] = [UUID: [Chat]]()
    
    /// Boolean that detirmines if the SearchOverlay is visible or not.
    /// The reason for having this variable stored in DataConglomerate is because the value has to persist between two views, MapView and SearchOverlay.
    @Published var searchOverlayActive: Bool = false
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
    
    var dateFormatter: DateFormatter = DateFormatter()
    
    func dateToNumericalString(date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm:ss dd/MM/YY"
        return dateFormatter.string(from: date)
    }
    
    func dataToString(tag: String) -> String {
        var dataString = ""
        if(queries[tag] == QueryStatus.result) {
            dataString = data[tag] as! String
        }
        return dataString
    }
    
    /// Returns a list of railyards in the user's map region. The number of railyards returned is dependent on the zoom of the region
    /// - Returns: List of railyards
    func conglomerateStoredRailyards() -> [Railyard] {
        if(region.span.longitudeDelta > 40) {
            return conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 0, railyardsDisplayedModOperator: 20, boundDimension: 5)
        } else if(region.span.longitudeDelta > 20) {
            return conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 0, railyardsDisplayedModOperator: 10, boundDimension: 3)
        } else if(region.span.longitudeDelta > 10) {
            return conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 10, railyardsDisplayedModOperator: 20, boundDimension: 1.5)
        } else if(region.span.longitudeDelta > 3) {
            return conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 99, railyardsDisplayedModOperator: 1, boundDimension: 0.5)
        } else if(region.span.longitudeDelta > 1) {
            return conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 99, railyardsDisplayedModOperator: 1, boundDimension: 0.2)
        } else {
            return conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: 99, railyardsDisplayedModOperator: 1, boundDimension: 0)
        }
    }
    
    /// Returns railyards contained in the user map region. Contains parameters to adjust number of railyards displayed.
    /// - Returns: A list of railyards, with railyards displayed concentrated in the middle of the map region.
    /// - Parameters:
    ///   - limitRailyardsDisplayedThreshold: number of railyards that are diplayed before limiting further railyards from getting displayed
    ///   - railyardsDisplayedFrequency: detirmines how often railyards are displayed after the limiter is active.
    func conglomerateRegionalStoredRailyards(railyardModOperatorActivationThreshold: Int, railyardsDisplayedModOperator: Int, boundDimension: CLLocationDegrees) -> [Railyard] {
        let userLongitudeRegionsTags = findLongitudeRegionsTags()
        let bound: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: boundDimension, longitude: boundDimension)
        var storedNearbyRailyards: [Railyard] = []
        if(userLongitudeRegionsTags.isEmpty) {
            return storedNearbyRailyards
        }
        var numRailyardsDisplayed: Int = 0
        var userLongitudeRegionTagsIndex: Int = 0
        var leftUserLongitudeRegionTags: [LongitudeRegionQueryTags] = []
        var rightUserLongitudeRegionTags: [LongitudeRegionQueryTags] = []
        if(userLongitudeRegionsTags.count == 1) {
            leftUserLongitudeRegionTags = userLongitudeRegionsTags
        } else {
            leftUserLongitudeRegionTags = Array((userLongitudeRegionsTags[0...(userLongitudeRegionsTags.count/2) - 1]))
            leftUserLongitudeRegionTags.reverse()
            rightUserLongitudeRegionTags = Array(userLongitudeRegionsTags[leftUserLongitudeRegionTags.count...])
        }
        while(userLongitudeRegionTagsIndex < leftUserLongitudeRegionTags.count || userLongitudeRegionTagsIndex < rightUserLongitudeRegionTags.count) {
            var regionStoredNearbyRailyards: [Railyard] = []
            if(userLongitudeRegionTagsIndex < leftUserLongitudeRegionTags.count) {
                if storedUserLongitudeRegions[leftUserLongitudeRegionTags[userLongitudeRegionTagsIndex].longitudeRegion] != nil {
                    let railyards = storedUserLongitudeRegions[leftUserLongitudeRegionTags[userLongitudeRegionTagsIndex].longitudeRegion]!
                    for railyardIndex in railyards.indices {
                        if((abs(railyards[railyardIndex].coordinates.latitude) - abs(region.center.latitude)) < (region.span.latitudeDelta/2)) {
                            if(boundDimension > 0 && railyardIndex > 0 && !regionStoredNearbyRailyards.isEmpty) {
                                var boundViolated: Bool = false
                                for regionStoredNearbyRailyard in regionStoredNearbyRailyards {
                                    if(CLLocationCoordinate2D.coordinatesWithinBound(lhs: railyards[railyardIndex].coordinates, rhs: regionStoredNearbyRailyard.coordinates, bound: bound)) {
                                        boundViolated = true
                                    }
                                }
                                if(!boundViolated) {
                                    if(numRailyardsDisplayed < railyardModOperatorActivationThreshold) {
                                        regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                        numRailyardsDisplayed += 1
                                    } else {
                                        if(railyardIndex % railyardsDisplayedModOperator == 0) {
                                            regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                            numRailyardsDisplayed += 1
                                        }
                                    }
                                }
                            } else {
                                if(numRailyardsDisplayed < railyardModOperatorActivationThreshold) {
                                    regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                    numRailyardsDisplayed += 1
                                } else {
                                    if(railyardIndex % railyardsDisplayedModOperator == 0) {
                                        regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                        numRailyardsDisplayed += 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(userLongitudeRegionTagsIndex < rightUserLongitudeRegionTags.count) {
                if storedUserLongitudeRegions[rightUserLongitudeRegionTags[userLongitudeRegionTagsIndex].longitudeRegion] != nil {
                    let railyards = storedUserLongitudeRegions[rightUserLongitudeRegionTags[userLongitudeRegionTagsIndex].longitudeRegion]!
                    for railyardIndex in railyards.indices {
                        if((abs(railyards[railyardIndex].coordinates.latitude) - abs(region.center.latitude)) < region.span.latitudeDelta) {
                            if(boundDimension > 0 && railyardIndex > 0 && !regionStoredNearbyRailyards.isEmpty) {
                                var boundViolated: Bool = false
                                for regionStoredNearbyRailyard in regionStoredNearbyRailyards {
                                    if(CLLocationCoordinate2D.coordinatesWithinBound(lhs: railyards[railyardIndex].coordinates, rhs: regionStoredNearbyRailyard.coordinates, bound: bound)) {
                                        boundViolated = true
                                    }
                                }
                                if(!boundViolated) {
                                    if(numRailyardsDisplayed < railyardModOperatorActivationThreshold) {
                                        regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                        numRailyardsDisplayed += 1
                                    } else {
                                        if(railyardIndex % railyardsDisplayedModOperator == 0) {
                                            regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                            numRailyardsDisplayed += 1
                                        }
                                    }
                                }
                            } else {
                                if(numRailyardsDisplayed < railyardModOperatorActivationThreshold) {
                                    regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                    numRailyardsDisplayed += 1
                                } else {
                                    if(railyardIndex % railyardsDisplayedModOperator == 0) {
                                        regionStoredNearbyRailyards.append(railyards[railyardIndex])
                                        numRailyardsDisplayed += 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
            storedNearbyRailyards.append(contentsOf: regionStoredNearbyRailyards)
            userLongitudeRegionTagsIndex += 1
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
    
    func getUserName(userId: String) -> String {
        var userName = ""
        let userNameTag = "user_" + userId + "_name_tag"
        if(queries[userNameTag] == QueryStatus.result) {
            userName = data[userNameTag] as! String
        } else if(queries[userNameTag] == QueryStatus.empty) {
            userName = ""
        } else {
            userName = "deleted user"
        }
        return userName
    }
    
    func clearWaittimeData() {
        storedAverageWaittimes = [UUID: TimeInterval]()
        storedWaittimes = [UUID: [Waittime]]()
    }
    
    func clearChatData() {
        storedChats = [UUID: [Chat]]()
    }
    
    func clearQuery(tag: String) {
        queries[tag] = nil
    }
    
    func clearRailyardQueries() {
        for key in queries.keys {
            //Railyard query tags are 49 characters
            if(key.count == 49) {
                queries[key] = nil
            }
        }
    }
    
    func clearWaittimeQueries() {
        for key in queries.keys {
            if(key.count == 58) {
                queries[key] = nil
            }
        }
    }
    
    func clearChatQueries() {
        for key in queries.keys {
            if(key.count == 54) {
                queries[key] = nil
            }
        }
    }
    
    func clearQueries() {
        queries = [String: QueryStatus]()
    }
    
    func refreshMapView() {
        clearRailyardQueries()
        clearWaittimeQueries()
        clearRailyardData()
        clearWaittimeData()
    }
    
    func clearFavoriteRailyards() {
        favoriteRailyards = [Railyard]()
    }
    
    func clearRegionalRailyards() {
        storedUserLongitudeRegions = [Int: [Railyard]]()
    }
    
    func clearRailyardData() {
        clearFavoriteRailyards()
        clearRegionalRailyards()
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

