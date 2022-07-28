//
//  DataConglomerate.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//
import Foundation

final class DataConglomerate: ObservableObject {
    @Published var data: [String: Any] = [String: Any]()
    @Published var query: [String: Any] = [String: Any]()
    
    func dataToString(tag: String) -> String {
        return data[tag] as! String
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

