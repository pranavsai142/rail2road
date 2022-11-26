//
//  RailyardRow.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import SwiftUI

struct RailyardRow: View {
    var railyard: Railyard
    var averageWaittimeMinutes: String
    var body: some View {
        HStack {
            Text(railyard.name)
            Spacer()
            Text(averageWaittimeMinutes)
        }
            .padding()
    }
}

struct RailyardRow_Previews: PreviewProvider {
    static var previews: some View {
        RailyardRow(railyard: Railyard(), averageWaittimeMinutes: "-")
    }
}
