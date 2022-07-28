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
    
    var uid: String
    var railyard: Railyard
    
    private func sendMessage() {
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(railyard.title)
                    .font(.title)
                    .padding()
                Spacer()
                Text(String(railyard.waittime))
                    .font(.title)
                    .padding()
                    .background(Color.green)
            }
                .background(Color.black.opacity(0.3))
            Spacer()
            ScrollView {
                ForEach(dataConglomerate.getChatHistory(railyard: railyard)) { chat in
                    if(Int.random(in: 0..<2) % 2 == 0) {
                        ChatBubble(chat: chat, sent: true)
                    } else {
                        ChatBubble(chat: chat, sent: false)
                    }
                }
            }
            HStack {
                TextField("Type here", text: $message)
                    .padding(.leading)
                    .padding(.trailing)
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "plus.message.fill")
                        .padding(.leading)
                        .padding(.trailing)
                }
            }
                .background(Color.black.opacity(0.1))
            
            NavigationLink(
                destination: ReportView(uid: uid, railyard: railyard)
                    .environmentObject(database)
                    .environmentObject(dataConglomerate)) {
                Text("report")
                    .padding(.bottom)
            }
        }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(uid: "1", railyard: Railyard(coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
    }
}
