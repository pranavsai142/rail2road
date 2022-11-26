//
//  Waittime.swift
//  Rail2Road
//
//  Created by pranav sai on 11/24/22.
//

import Foundation

struct Waittime: Identifiable, Comparable, Equatable {
    static func < (lhs: Waittime, rhs: Waittime) -> Bool {
        return lhs.endtime < rhs.endtime
    }
    
    static func == (lhs: Waittime, rhs: Waittime) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    let userId: String
    let endtime: Date
    let delta: TimeInterval

    init(id: UUID, dictionary: NSDictionary) {
        self.id = id
        self.userId = dictionary.value(forKey: "user") as! String
        self.endtime = Date(timeIntervalSince1970: (dictionary.value(forKey: "endtime") as! TimeInterval))
        self.delta = dictionary.value(forKey: "delta") as! TimeInterval
    }
    
    init(id: UUID, userId: String, endtime: Date, delta: TimeInterval) {
        self.id = id
        self.userId = userId
        self.endtime = endtime
        self.delta = delta
    }
}

