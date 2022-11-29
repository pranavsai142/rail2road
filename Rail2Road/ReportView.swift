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
    
    @State private var startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
    @State private var endDate = Date()
    
    var uid: String
    var railyard: Railyard
    
    var minDateConstraints: ClosedRange<Date> {
        //Min date constraints
        let minDate = Calendar.current.date(byAdding: .hour, value: -12, to: Date())!
        let maxDate = Calendar.current.date(byAdding: .minute, value: -1, to: Date())!
        return minDate...maxDate
    }
    
    var maxDateConstraints: ClosedRange<Date> {
        //Max date constraints
        let minDate = startDate
        let maxDate = Date()
        return minDate...maxDate
    }
    
    private func submit() {
        //The following data has to be submitted into firebase, as long as submission valid.
        //endtime: millesecond timestamp
        //User uid: string
        //delta: millesecond time duration
        //railyard uid: string
        if(!(startDate.distance(to: endDate).isLessThanOneMinute())) {
            let waittime = Waittime(id: UUID(), userId: uid, endtime: endDate, delta: startDate.distance(to: endDate))
            database.setValue(path:  ["railyards", railyard.id.uuidString, "waittimes", waittime.id.uuidString, "user"], value: waittime.userId)
            database.setValue(path:  ["railyards", railyard.id.uuidString, "waittimes", waittime.id.uuidString, "endtime"], value: waittime.endtime.timeIntervalSince1970)
            database.setValue(path:  ["railyards", railyard.id.uuidString, "waittimes", waittime.id.uuidString, "delta"], value: waittime.delta)
            dataConglomerate.clearQuery(tag: "railyard_" + railyard.id.uuidString + "_waittime_tag")
        }
    }
    
    var body: some View {
        VStack {
            Text("Truthful reporting delivers accurate data!")
                .italic()
                .font(.caption)
            Divider()
            DatePicker("Start:", selection: $startDate, in: minDateConstraints, displayedComponents: [.date, .hourAndMinute])
            DatePicker("End:", selection: $endDate, in: maxDateConstraints, displayedComponents: [.date, .hourAndMinute])
            Spacer()
            HStack {
                Text("Wait Duration: \(startDate.distance(to: endDate).toString())")
                    .bold()
                Spacer()
                Button(action: {
                    submit()
                }) {
                    Text("submit")
                }
            }
        }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("Report Wait Time"))
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(uid: "1", railyard: Railyard())
    }
}
