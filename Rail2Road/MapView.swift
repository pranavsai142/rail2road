//
//  MapView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import MapKit

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

struct MapView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @StateObject var locationManager = LocationManager()
    
//    @State private var railyards = [Railyard(coordinates: CLLocationCoordinate2D(latitude: 42.1033585, longitude: -88.3726605)), Railyard(coordinates: CLLocationCoordinate2D(latitude: 42.1043585, longitude: -88.3736605)),
//                                    Railyard(coordinates: CLLocationCoordinate2D(latitude: 37.873972, longitude: -122.51297))]
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))

    var uid: String
    
    var query: Bool {
        let userLongitudeRegionsTags = findLongitudeRegionsTags(region: region)
        //QueryTag struct {foundTag: String, tag: String} Used for retriving values from firebase
        DispatchQueue.main.async {
            var userLongitudeRegionsQueryTags: [LongitudeRegionQueryTags] = []
            for userLongitudeRegionTags in userLongitudeRegionsTags {
//                print(pairingFunction(userRailyardRegionTags: userRailyardRegionTags))
                if(dataConglomerate.storedUserLongitudeRegions[userLongitudeRegionTags.longitudeRegion] == nil) {
                    userLongitudeRegionsQueryTags.append(userLongitudeRegionTags)
                }
            }
            for userLongitudeRegionQueryTags in userLongitudeRegionsQueryTags {
                _ = database.queryDatabaseByRegion(path: ["railyards"], queryTags: userLongitudeRegionQueryTags, dataConglomerate: dataConglomerate)
            }
        }
        return true
    }
    
//    private func pairingFunction(userRailyardRegionTags: RailroadRegionQueryTags) -> Int {
//        return userRailyardRegionTags.latitudeRegion + 360 * (userRailyardRegionTags.longitudeRegion % 360)
//    }
    
    
    private func findLongitudeRegionsTags(region: MKCoordinateRegion) -> [LongitudeRegionQueryTags] {
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
    
//    private func findRailyardRegionsTags(region: MKCoordinateRegion) -> [RailroadRegionQueryTags] {
//        var latitudeRegions: [Int] = []
//        let bottomBound = region.center.latitude - (region.span.latitudeDelta/2.0)
//        let topBound = region.center.latitude + (region.span.latitudeDelta/2.0)
//
//        latitudeRegions.append(contentsOf: splitIntoLatitudeRegions(bottomBound: bottomBound, topBound: topBound))
//
//        var longitudeRegions: [Int] = []
//        var leftBound = region.center.longitude - (region.span.longitudeDelta/2.0)
//        var rightBound = region.center.longitude + (region.span.longitudeDelta/2.0)
//
//        if (leftBound < -180.0) {
//            longitudeRegions.append(contentsOf: splitIntoLongitudeRegions(leftBound: leftBound + 360, rightBound: 180.0))
//            leftBound = -180.0
//        } else if (rightBound > 180.0) {
//            longitudeRegions.append(contentsOf: splitIntoLongitudeRegions(leftBound: -180.0, rightBound: rightBound - 360.0))
//            rightBound = 180.0
//        }
//        longitudeRegions.append(contentsOf: splitIntoLongitudeRegions(leftBound: leftBound, rightBound: rightBound))
//
//        let queryTags = concatIntoQueryTags(latitudeRegions: latitudeRegions, longitudeRegions: longitudeRegions)
//        return queryTags
//    }

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
    
//    private func concatIntoQueryTags(latitudeRegions: [Int], longitudeRegions: [Int]) -> [RailroadRegionQueryTags] {
//        var queryTags: [RailroadRegionQueryTags] = []
//        for latitudeRegion in latitudeRegions {
//            for longitudeRegion in longitudeRegions {
//                queryTags.append(RailroadRegionQueryTags(latitudeRegion: latitudeRegion, longitudeRegion: longitudeRegion))
//            }
//        }
//        return queryTags
//    }

    private func zoomIn() {
        DispatchQueue.main.async {
            region.span.latitudeDelta *= 0.9
            region.span.longitudeDelta *= 0.9
        }
    }
    
    private func zoomOut() {
        DispatchQueue.main.async {
            let newLatitudeDelta = region.span.latitudeDelta * 1.1
            let newLongitudeDelta = region.span.longitudeDelta * 1.1
            if(newLatitudeDelta < 126.65) {
                region.span.latitudeDelta = newLatitudeDelta
            } else {
                //Max latitude delta for Apple Maps
                region.span.latitudeDelta = 126.65
            }
            if(newLongitudeDelta < 108.689) {
                region.span.longitudeDelta = newLongitudeDelta
            } else {
                //Max longitude delta for appple maps
                region.span.longitudeDelta = 108.689
            }
        }
    }
    
    private func goToCurrentLocation() {
        DispatchQueue.main.async {
            region = locationManager.region
        }
    }
    
    private func search() {
        
    }
    
//    private func printQuery() -> Bool {
//        if(dataConglomerate.query[railyardsTag] != nil) {
////            print(dataConglomerate.query[railyardsTag])
//        }
//        return true
//    }
    
    var body: some View {
        if(query) {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: dataConglomerate.storedRailyards) { railyard in
                    MapAnnotation(coordinate: railyard.coordinates) {
                        NavigationLink(destination: DetailView(uid: uid, railyard: railyard)
                                        .environmentObject(database)
                                        .environmentObject(dataConglomerate)) {
                            RailyardAnnotation(railyard: railyard)
                        }
                    }
                }
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack(alignment: .top) {
                        NavigationLink(
                            destination: AccountView(uid: uid)
                                .environmentObject(database)
                                .environmentObject(dataConglomerate)) {
                            Image(systemName: "person.crop.circle.fill")
                                .padding(.leading)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: HorizontalAlignment.trailing) {
                            Button(action: {
                                zoomIn()
                            }, label: {
                                Image(systemName: "plus.square.fill")
                                    .padding(.trailing)
                            })
                            Button(action: {
                                zoomOut()
                            }, label: {
                                Image(systemName: "minus.square.fill")
                                    .padding(.trailing)
                            })
                            Button(action: {
                                goToCurrentLocation()
                            }, label: {
                                Image(systemName: "location.fill.viewfinder")
                                    .padding(.trailing)
                            })
                        }
                    }
                        .padding(.top)
                    Spacer()
                    HStack {
                        Button(action: {
                            search()
                        }, label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .padding(.leading)
                                .padding(.bottom)
                                .padding(.bottom)
                        })
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                goToCurrentLocation()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(uid: "1")
    }
}
