//
//  ReportView.swift
//  Rail2Road
//
//  Created by Pranav Sai on 5/1/22.
//

import SwiftUI

extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

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
        
    }
    

    private func timeIntervalToString(delta: TimeInterval) -> String {
        if(delta <= 1) {
            return "Invalid Input"
        }
        
        var returnString = ""
        
        if(delta.hour == 1) {
            returnString = returnString + String(delta.hour) + " hour"
        } else if(delta.hour > 1) {
            returnString = returnString + String(delta.hour) + " hours"
        }
        
        if(delta.minute == 1) {
            returnString = returnString + " " + String(delta.minute) + " minute"
        } else if(delta.minute > 1) {
            returnString = returnString + " " + String(delta.minute) + " minutes"
        }

//        if(delta.second == 1) {
//            returnString = returnString + " " + String(delta.second) + " second"
//        } else if(delta.second > 1) {
//            returnString = returnString + " " + String(delta.second) + " seconds"
//        }
        
        return returnString
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
                Text("Wait Duration: \(timeIntervalToString(delta: (startDate.distance(to: endDate))))")
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
