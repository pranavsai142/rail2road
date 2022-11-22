//
//  TimeIntervalExtension.swift
//  Rail2Road
//
//  Created by pranav sai on 11/21/22.
//

import Foundation

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
    
    
    func toString() -> String {
        if(self <= 1) {
            return "Invalid Input"
        }
        
        var returnString = ""
        
        if(self.hour == 1) {
            returnString = returnString + String(self.hour) + " hour"
        } else if(self.hour > 1) {
            returnString = returnString + String(self.hour) + " hours"
        }
        
        if(self.minute == 1) {
            returnString = returnString + " " + String(self.minute) + " minute"
        } else if(self.minute > 1) {
            returnString = returnString + " " + String(self.minute) + " minutes"
        }

//        if(delta.second == 1) {
//            returnString = returnString + " " + String(delta.second) + " second"
//        } else if(delta.second > 1) {
//            returnString = returnString + " " + String(delta.second) + " seconds"
//        }
        
        return returnString
    }
    
    func toMinutesString() -> String {
        if(self <= 59) {
            return "Invalid Input"
        }
        
        var returnString = ""

        let minutes = self/60
        if(minutes == 1) {
            returnString = returnString + " " + String(minutes) + " minute"
        } else if(self.minute > 1) {
            returnString = returnString + " " + String(minutes) + " minutes"
        }
        
        return returnString
    }
}
