//
//  Region.swift
//  Rail2Road
//
//  Created by pranav sai on 8/17/22.
//

import MapKit

struct RailyardRegion: Identifiable, Equatable {
    static func == (lhs: RailyardRegion, rhs: RailyardRegion) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    let id: UUID
    let queryTags: RailroadRegionQueryTags
    let railyards: [Railyard]
    init(queryTags: RailroadRegionQueryTags, railyards: [Railyard]) {
        self.id = UUID()
        self.railyards = railyards
        self.queryTags = queryTags
    }
//    init(tree: Any?) {
//        self.id = UUID()
//        self.railyards = []
//        self.tag = Qu
//    }
}
