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
    
    var railyardFavoriteTag: String {
        return "railyard_" + railyard.id.uuidString + "_favorite_tag"
    }
    
    var query: Bool {
        DispatchQueue.main.async {
            _ = database.getValue(path: ["users", uid, "favorites"], key: railyard.id.uuidString, tag: railyardFavoriteTag, dataConglomerate: dataConglomerate)
            _ = setFavorite()
            _ = generateChat()
            _ = generateUserNames()
        }
        return true
    }
    
    private func setFavorite() -> Bool {
        if(dataConglomerate.queries[railyardFavoriteTag] == DataConglomerate.QueryStatus.result) {
            isFavorite = true
        } else {
            isFavorite = false
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
    
    private func generateUserNames() -> Bool {
        let chatTag = "railyard_" + railyard.id.uuidString + "_chat_tag"
        if(dataConglomerate.queries[chatTag] == DataConglomerate.QueryStatus.result) {
            for chat in dataConglomerate.storedChats[railyard.id]! {
                _ = database.getValue(path: ["users", chat.userId], key: "name", tag: "user_" + chat.userId + "_name_tag", dataConglomerate: dataConglomerate)
            }
        }
        return true
    }
    
    private func sendChat() {
        let chat = Chat(id: UUID(), timestamp: Date(), message: message, userId: uid)
        database.setValue(path:  ["railyards", railyard.id.uuidString, "chat", chat.id.uuidString, "user"], value: chat.userId)
        database.setValue(path:  ["railyards", railyard.id.uuidString, "chat", chat.id.uuidString, "timestamp"], value: chat.timestamp.timeIntervalSince1970)
        database.setValue(path:  ["railyards", railyard.id.uuidString, "chat", chat.id.uuidString, "message"], value: chat.message)
        dataConglomerate.queries["railyard_" + railyard.id.uuidString + "_chat_tag"] = nil
    }
    
    private func toggleFavorite() {
        if(isFavorite) {
            isFavorite = false
            database.removeValue(path: ["users", uid, "favorites", railyard.id.uuidString])
        } else {
            isFavorite = true
            database.setValue(path: ["users", uid, "favorites", railyard.id.uuidString], value: true)
        }
        dataConglomerate.clearQuery(tag: railyardFavoriteTag)
        dataConglomerate.clearQuery(tag: "user_favorites_tag")
        dataConglomerate.clearRailyardQueries()
        dataConglomerate.clearFavoriteRailyards()
    }
    
    var body: some View {
        if(query) {
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
                                    .environmentObject(dataConglomerate)
                            } else {
                                ChatBubble(chat: chat, sent: false)
                                    .environmentObject(dataConglomerate)
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
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(uid: "1", railyard: Railyard())
    }
}
