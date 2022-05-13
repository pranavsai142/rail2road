//
//  MapView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var railyards = [Railyard(coordinates: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)), Railyard(coordinates: CLLocationCoordinate2D(latitude: 51.307222, longitude: -0.2375))]
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: railyards) { railyard in
                MapAnnotation(coordinate: railyard.coordinates) {
                    NavigationLink(destination: DetailView()) {
                        RailyardAnnotation(railyard: railyard)
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
                        .padding()
                    
                    Spacer()
                    
                    Button("Location", action: {
                        
                    })
                        .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
