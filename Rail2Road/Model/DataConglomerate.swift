//
//  DataConglomerate.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//
import Foundation

final class DataConglomerate: ObservableObject {
    /// data dictionary. Use for local storage of metadata like information
    @Published var data: [String: Any] = [String: Any]()
    /// query dictionary. Used for data originating from Firebase Realtime Database.
    @Published var query: [String: Any] = [String: Any]()
    /// dictionary containing locally saved railyard regions, key of the dictionary being a RailyardRegionQueryTag
    @Published var storedUserRailyardRegions: [RailroadRegionQueryTags: RailyardRegion] = [RailroadRegionQueryTags: RailyardRegion]()
    
    func dataToString(tag: String) -> String {
        return data[tag] as! String
    }
    
    func conglomerateRailyards(storedUserRailyardRegionsTags: [RailroadRegionQueryTags]) -> [Railyard] {
        var railyards: [Railyard] = []
        for storedUserRailyardRegionTags in storedUserRailyardRegionsTags {
            if storedUserRailyardRegions[storedUserRailyardRegionTags] != nil {
                railyards.append(contentsOf: storedUserRailyardRegions[storedUserRailyardRegionTags]!.railyards)
            }
        }
        return railyards
    }
    
    func getChatHistory(railyard: Railyard) -> [Chat] {
        var chatHistory: [Chat] = []
        chatHistory.append(Chat(message: "Quick, fast service"))
        chatHistory.append(Chat(message: "Just left this depot. moving fast now."))
        chatHistory.append(Chat(message: "Where are some good lodges around here?"))
        chatHistory.append(Chat(message: "Quick, fast service"))
        chatHistory.append(Chat(message: "Just left this depot. moving fast now."))
        chatHistory.append(Chat(message: "Where are some good lodges around here?"))
        chatHistory.append(Chat(message: "Quick, fast service"))
        chatHistory.append(Chat(message: "Just left this depot. moving fast now."))
        chatHistory.append(Chat(message: "Where are some good lodges around here?"))
        return chatHistory
    }
}

