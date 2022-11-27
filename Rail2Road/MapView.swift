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
    
    @State private var listOverlayActive: Bool = true
    @State private var viewFavoriteRailyards: Bool = true
    
    @State private var userFavoritesTag: String = "user_favorites_tag"

    var uid: String
    
    var userFavoritesPath: [String] {
        ["users", uid, "favorites"]
    }
    
    var query: Bool {
        print("\n", dataConglomerate.queries)
        let userLongitudeRegionsTags = dataConglomerate.findLongitudeRegionsTags()
        //QueryTag struct {foundTag: String, tag: String} Used for retriving values from firebase
        DispatchQueue.main.async {
            _ = database.getValues(path: userFavoritesPath, tag: userFavoritesTag, dataConglomerate: dataConglomerate)
            _ = generateFavorites()
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
            _ = generateWaittimes()
        }
        return true
    }
    
    //    A helper function to create Railyard objects based on all the user's favorite railyards
        private func generateFavorites() -> Bool {
    //        Array of user's subscription's uids
            if dataConglomerate.queries[userFavoritesTag] == DataConglomerate.QueryStatus.result {
                let userFavoritesIds = dataConglomerate.data[userFavoritesTag] as! NSArray
                for id in userFavoritesIds {
                    let id = (id as! String)
    //                Define tags to act as keys to access data in the database
                     let railyardTag = "railyard_" + id + "_tag"

                    _ = database.getRailyard(id: id, tag: railyardTag, dataConglomerate: dataConglomerate)
                }
                return true
            }
            else {
                return false
            }
        }
    
    private func generateWaittimes() -> Bool {
//        dataConglomerate.clearWaittimeData()
        for railyard in dataConglomerate.conglomerateAllStoredRailyards() {
            let startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            let endDate = Date()
            let tag = "railyard_" + railyard.id.uuidString + "_waittime_tag"
            _ = database.queryWaittimeDatabaseByTime(path: ["railyards"], railyardId: railyard.id, startDate: startDate, endDate: endDate, tag: tag, dataConglomerate: dataConglomerate)
        }
        return true
    }
    
//    private func pairingFunction(userRailyardRegionTags: RailroadRegionQueryTags) -> Int {
//        return userRailyardRegionTags.latitudeRegion + 360 * (userRailyardRegionTags.longitudeRegion % 360)
//    }
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
            dataConglomerate.region.span.latitudeDelta *= 0.9
            dataConglomerate.region.span.longitudeDelta *= 0.9
        }
    }
    
    private func zoomOut() {
        DispatchQueue.main.async {
            let newLatitudeDelta = dataConglomerate.region.span.latitudeDelta * 1.1
            let newLongitudeDelta = dataConglomerate.region.span.longitudeDelta * 1.1
            if(newLatitudeDelta < 126.65) {
                dataConglomerate.region.span.latitudeDelta = newLatitudeDelta
            } else {
                //Max latitude delta for Apple Maps
                dataConglomerate.region.span.latitudeDelta = 126.65
            }
            if(newLongitudeDelta < 108.689) {
                dataConglomerate.region.span.longitudeDelta = newLongitudeDelta
            } else {
                //Max longitude delta for appple maps
                dataConglomerate.region.span.longitudeDelta = 108.689
            }
        }
    }
    
    private func goToCurrentLocation() {
        DispatchQueue.main.async {
            dataConglomerate.region = locationManager.region
        }
    }
    
    private func search() {
        dataConglomerate.searchOverlayActive = true
    }
    
//    private func printQuery() -> Bool {
//        if(dataConglomerate.query[railyardsTag] != nil) {
////            print(dataConglomerate.query[railyardsTag])
//        }
//        return true
//    }
    
    var body: some View {
        if(query) {
            if(listOverlayActive) {
                VStack {
                    HStack {
                        Button(action: {
                            listOverlayActive = false
                        }, label: {
                            Image(systemName: "chevron.compact.up")
                        })
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            viewFavoriteRailyards = !viewFavoriteRailyards
                        }, label: {
                            if(viewFavoriteRailyards) {
                                Image(systemName: "star.fill")
                            } else {
                                Image(systemName: "star")
                            }
                        })
                            .padding(.trailing)
                    }
                    //If ListOverlay should have accessibility to SearchOverlay,
                    //add conditional displaying SearchOverlay if dataConglomerate.searchOverlayActive else display ListOverlay.
                    ListOverlay(uid: uid, viewFavoriteRailyards: viewFavoriteRailyards)
                        .environmentObject(database)
                        .environmentObject(dataConglomerate)
                }
                    .background(Color.black)
                    .opacity(0.8)
                    .navigationBarHidden(true)
                    .onAppear {
                        goToCurrentLocation()
                    }
            } else {
                ZStack {
                    Map(coordinateRegion: $dataConglomerate.region, showsUserLocation: true, annotationItems: dataConglomerate.conglomerateRegionalStoredRailyards()) { railyard in
                        MapAnnotation(coordinate: railyard.coordinates) {
                            NavigationLink(destination: DetailView(uid: uid, railyard: railyard)
                                            .environmentObject(database)
                                            .environmentObject(dataConglomerate)) {
                                RailyardAnnotation(railyard: railyard, averageWaittimeMinutes: dataConglomerate.waittimeToMinutes(railyardId: railyard.id))
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
                                dataConglomerate.searchOverlayActive = true
                            }, label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .padding(.leading)
                                    .padding(.bottom)
                                    .padding(.bottom)
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                listOverlayActive = true
                            }, label: {
                                Image(systemName: "list.bullet.circle.fill")
                                    .padding(.trailing)
                                    .padding(.bottom)
                                    .padding(.bottom)
                            })
                        }
                    }
                    if(dataConglomerate.searchOverlayActive) {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    dataConglomerate.searchOverlayActive = false
                                }, label: {
                                    Image(systemName: "chevron.compact.up")
                                })
                                Spacer()
                            }
                                .padding(.bottom)
                            SearchOverlay()
                        }
                            .background(Color.black)
                            .opacity(0.8)
                    }
                }
                    .navigationBarHidden(true)
                    .onAppear {
                        goToCurrentLocation()
                    }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(uid: "1")
    }
}
