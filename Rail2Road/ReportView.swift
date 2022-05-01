//
//  ReportView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("report")
                NavigationLink(
                    destination: DetailView()) {
                    Text("back")
                }
            }
        }
            .navigationBarHidden(true)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
