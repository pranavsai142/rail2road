//
//  MapView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @StateObject var locationManager = LocationManager()
    
    @State private var railyards = [Railyard(coordinates: CLLocationCoordinate2D(latitude: 42.1033585, longitude: -88.3726605)), Railyard(coordinates: CLLocationCoordinate2D(latitude: 42.1043585, longitude: -88.3736605)),
                                    Railyard(coordinates: CLLocationCoordinate2D(latitude: 37.873972, longitude: -122.51297))]
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))

    var uid: String
    
    
    private func zoomIn() {
        DispatchQueue.main.async {
            region.span.latitudeDelta *= 0.9
            region.span.longitudeDelta *= 0.9
        }
    }
    
    private func zoomOut() {
        DispatchQueue.main.async {
            region.span.latitudeDelta *= 1.1
            region.span.longitudeDelta *= 1.1
        }
    }
    
    private func goToCurrentLocation() {
        DispatchQueue.main.async {
            region = locationManager.region
        }
    }
    
    private func search() {
        
    }

    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: railyards) { railyard in
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(uid: "1")
    }
}
