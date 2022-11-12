//
//  DetailView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var message: String = ""
    @State private var isFavorite: Bool = false
    
    var uid: String
    var railyard: Railyard
    
    private func sendMessage() {
        
    }
    
    private func toggleFavorite() {
        if(isFavorite) {
            isFavorite = false
        } else {
            isFavorite = true
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(railyard.address)
                    .font(.caption)
                Spacer()
                Button(action: {
                    toggleFavorite()
                }, label: {
                    if(isFavorite) {
                        Image(systemName: "star.fill")
                    } else {
                        Image(systemName: "star")
                    }
                })
                Text(String(railyard.waittime))
                    .font(.title)
                    .bold()
                    .padding()
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
                .padding()
            ScrollView {
                ForEach(dataConglomerate.getChatHistory(railyard: railyard)) { chat in
                    if(Int.random(in: 0..<2) % 2 == 0) {
                        ChatBubble(chat: chat, sent: true)
                    } else {
                        ChatBubble(chat: chat, sent: false)
                    }
                }
            }
        }
            .navigationTitle(railyard.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(uid: "1", railyard: Railyard(coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
    }
}
