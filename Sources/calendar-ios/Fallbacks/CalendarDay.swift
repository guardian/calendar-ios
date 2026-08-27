import SwiftUI

/// Internal fallback day model used when callers do not provide a day for a date.
struct CalendarDay: CalendarRepresentable {
    var id: Date { date }
    let date: Date
    var color: Color?
    var isToday: Bool = false
    var isSelected: Bool = false
}
