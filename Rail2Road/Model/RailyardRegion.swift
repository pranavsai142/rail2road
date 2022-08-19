//
//  Region.swift
//  Rail2Road
//
//  Created by pranav sai on 8/17/22.
//

import MapKit

struct RailyardRegion: Identifiable {
    let id: UUID
    let tag: String
    let railyards: [Railyard]
    init(tag: String, railyards: [Railyard]) {
        self.id = UUID()
        self.railyards = railyards
        self.tag = tag
    }
}
