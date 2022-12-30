//
//  Chat.swift
//  Rail2Road
//
//  Created by Pranav Sai on 7/25/22.
//
import Foundation

struct Chat: Identifiable, Comparable, Equatable {
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.timestamp.timeIntervalSince1970 < rhs.timestamp.timeIntervalSince1970
    }
    
    static func > (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.timestamp.timeIntervalSince1970 > rhs.timestamp.timeIntervalSince1970
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    let timestamp: Date
    let message: String
    let userId: String
    
    init(id: UUID, dictionary: NSDictionary) {
        self.id = id
        self.timestamp = Date(timeIntervalSince1970: (dictionary.value(forKey: "timestamp") as! TimeInterval))
        self.message = dictionary.value(forKey: "message") as! String
        self.userId = dictionary.value(forKey: "user") as! String
    }
    
    init(id: UUID, timestamp: Date, message: String, userId: String) {
        self.id = id
        self.timestamp = timestamp
        self.message = message
        self.userId = userId
    }
}
