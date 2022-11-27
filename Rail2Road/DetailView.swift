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
    
    var query: Bool {
        DispatchQueue.main.async {
            _ = generateChat()
        }
        return true
    }
    
    private func generateChat() -> Bool {
        let startDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let endDate = Date()
        let tag = "railyard_" + railyard.id.uuidString + "_chat_tag"
        _ = database.queryChatDatabaseByTime(path: ["railyards"], railyardId: railyard.id, startDate: startDate, endDate: endDate, tag: tag, dataConglomerate: dataConglomerate)
        return true
    }
    
    private func sendChat() {
        
    }
    
    private func toggleFavorite() {
        if(isFavorite) {
            isFavorite = false
        } else {
            isFavorite = true
        }
    }
    
    var body: some View {
//        if(dataConglomerate.reportOverlayActive) {
//            VStack {
//                HStack {
//                    Button(action: {
//                        dataConglomerate.reportOverlayActive = false
//                    }, label: {
//                        Image(systemName: "chevron.compact.up")
//                    })
//                }
//                ReportOverlay(uid: uid, railyard: railyard)
//                    .environmentObject(database)
//                    .environmentObject(dataConglomerate)
//            }
//                .background(Color.black)
//                .opacity(0.2)
//                .navigationBarTitleDisplayMode(.inline)
//        } else {
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
                NavigationLink(
                    destination: ReportView(uid: uid, railyard: railyard)
                        .environmentObject(database)
                        .environmentObject(dataConglomerate)) {
                    VStack {
                        Text(dataConglomerate.waittimeToMinutes(railyardId: railyard.id))
                            .font(.title)
                            .bold()
                            .padding()
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("Report Wait Time")
                            .font(.caption)
                    }
                }
            }
                .padding(.leading)
                .padding(.trailing)
            ScrollView {
                if(dataConglomerate.storedChats[railyard.id] == nil) {
                    Text("Chat History Empty!")
                } else {
                    ForEach(dataConglomerate.storedChats[railyard.id]!) { chat in
                        if(uid == chat.userId) {
                            ChatBubble(chat: chat, sent: true)
                        } else {
                            ChatBubble(chat: chat, sent: false)
                        }
                    }
                }
            }
            HStack {
                TextField("type message", text: $message)
                    .textFieldStyle(.roundedBorder)
                Button(action: {
                    sendChat()
                }, label: {
                    Image(systemName: "arrow.up.square.fill")
                })
            }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
        }
            .navigationTitle(railyard.name)
            .navigationBarTitleDisplayMode(.large)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(uid: "1", railyard: Railyard())
    }
}
