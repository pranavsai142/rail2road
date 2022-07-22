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
    
    @State private var railyards = [Railyard(coordinates: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)), Railyard(coordinates: CLLocationCoordinate2D(latitude: 51.307222, longitude: -0.2375))]
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

    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: railyards) { railyard in
                MapAnnotation(coordinate: railyard.coordinates) {
                    NavigationLink(destination: DetailView()) {
                        RailyardAnnotation(railyard: railyard)
                    }
                }
            }
            VStack {
                HStack {
                    NavigationLink(
                        destination: AccountView(uid: uid)
                            .environmentObject(database)
                            .environmentObject(dataConglomerate)) {
                        Text("Account")
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: HorizontalAlignment.trailing) {
                        Button("North", action: {
                            
                        })
                            .padding(.trailing)
                        Button("Zoom In", action: {
                            zoomIn()
                        })
                            .padding(.trailing)
                        Button("Zoom Out", action: {
                            zoomOut()
                        })
                            .padding(.trailing)
                    }
                }
                Spacer()
                HStack {
                    Button("Search", action: {
                        
                    })
                        .padding()
                    
                    Spacer()
                    
                    Button("Location", action: {
                        goToCurrentLocation()
                    })
                        .padding()
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
