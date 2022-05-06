//
//  RailyardAnnotation.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/5/22.
//

import SwiftUI

struct RailyardAnnotation: View {
    var railyard: Railyard
    var body: some View {
        Text(railyard.title)
            .frame(width: 44, height: 44)
    }
}
