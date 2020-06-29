//
//  Date+Subtract.swift
//  HomeGuide
//
//  Created by minsoo kim on 2020/06/29.
//  Copyright © 2020 minsoo kim. All rights reserved.
//

import Foundation
extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}
extension Date{
    func getString()-> String{
        let month  = Calendar.current.dateComponents([.month], from:self).month
        let day = Calendar.current.dateComponents([.day], from:self).day
        var string = ""
        if month != nil{
            string = String(month!) + "월"
        }
        if day != nil{
            string = string + String(day!) + "일"
        }
        return string
    }
}
