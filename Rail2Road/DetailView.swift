//
//  DetailView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Details")
                NavigationLink(
                    destination: ReportView()) {
                    Text("report")
                }
                NavigationLink(
                    destination: MapView()) {
                    Text("back")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
