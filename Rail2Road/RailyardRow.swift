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
                .bold()
            Spacer()
            Text(averageWaittimeMinutes)
                .bold()
                .padding()
                .background(Railyard.waittimeToColor(waittime: averageWaittimeMinutes))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
    }
}

struct RailyardRow_Previews: PreviewProvider {
    static var previews: some View {
        RailyardRow(railyard: Railyard(), averageWaittimeMinutes: "-")
    }
}
