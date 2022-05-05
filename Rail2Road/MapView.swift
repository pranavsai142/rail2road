//
//  MapView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var place = IdentifiablePlace(coords: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: [place]) { place in
                    MapAnnotation(coordinate: place.coordinates) {
                        NavigationLink(destination: DetailView()) {
                            Circle()
                                .frame(width: 44, height: 44)
                        }
                    }
                }
                VStack {
                    HStack {
                        NavigationLink(
                            destination: AccountView()) {
                            Text("Account")
                                .padding()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: HorizontalAlignment.trailing) {
                            Button("North", action: {
                                
                            })
                                .padding(.trailing)
                            Button("Zoom In", action: {
                                
                            })
                                .padding(.trailing)
                            Button("Zoom Out", action: {
                                
                            })
                                .padding(.trailing)
                        }
                    }
                    Spacer()
                    HStack {
                        Button("Search", action: {
                            
                        })
                        
                        Spacer()
                        
                        Button("Location", action: {
                            
                        })
                    }
                }
            }
            .navigationBarHidden(true)
        }
            .navigationBarHidden(true)
    }
}

struct mapOverlay: View {
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: DetailView()) {
                Text("Detail")
            }
            
            Spacer()
            
            NavigationLink(
                destination: AccountView()) {
                Text("account")
            }
        }
    }
}

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let coordinates: CLLocationCoordinate2D
    init(id: UUID = UUID(), coords: CLLocationCoordinate2D) {
        self.id = id
        self.coordinates = coords
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
