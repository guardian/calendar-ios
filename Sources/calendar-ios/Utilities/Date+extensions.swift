//
//  File.swift
//  calendar-ios
//
//  Created by Usman_Nazir on 27/08/2026.
//

import Foundation

extension Date {
    
    private var calendar: Calendar {
        Calendar(identifier: .gregorian)
    }
    
    var beginningOfDay: Date {
        calendar.startOfDay(for: self)
    }
    
    var monthAndYear: Date {
        let components = calendar.dateComponents([.month, .year], from: self)
        return calendar.date(from: components) ?? .now
    }
    
    func adding(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0, nanoseconds: Int = 0) -> Date? {
        var components = DateComponents()
        components.year = years
        components.month = months
        components.day = days
        components.hour = hours
        components.minute = minutes
        components.second = seconds
        components.nanosecond = nanoseconds
        
        return calendar.date(byAdding: components, to: self) ?? .now
    }
    
    var isToday: Bool {
        calendar.isDateInToday(self)
    }
    
    func isSameDay(as date: Date) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }
}
