//
//  ReportView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var uid: String
    var railyard: Railyard
    
    private func submit() {
        
    }
    
    var body: some View {
        VStack {
            Text("Report")
            DatePicker("Start:", selection: $startDate)
            DatePicker("End:", selection: $endDate)
            Spacer()
            Button(action: {
                submit()
            }) {
                Text("submit")
            }
        }
            .padding()
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(uid: "1", railyard: Railyard())
    }
}
