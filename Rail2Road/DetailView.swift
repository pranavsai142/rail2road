//
//  DetailView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack {
            Text("Railyard Info")
            NavigationLink(
                destination: ReportView()) {
                Text("report")
            }
        }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
