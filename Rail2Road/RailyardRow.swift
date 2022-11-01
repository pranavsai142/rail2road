//
//  RailyardRow.swift
//  Rail2Road
//
//  Created by pranav sai on 10/31/22.
//

import SwiftUI

struct RailyardRow: View {
    var railyard: Railyard
    var body: some View {
        HStack {
            Text(railyard.name)
            Spacer()
            Text(String(railyard.waittime))
        }
            .padding()
    }
}

struct RailyardRow_Previews: PreviewProvider {
    static var previews: some View {
        RailyardRow(railyard: Railyard())
    }
}
