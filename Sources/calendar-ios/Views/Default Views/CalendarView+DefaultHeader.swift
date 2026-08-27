import SwiftUI

public extension CalendarView where Header == CalendarHeaderView {
    init(
        days: [any CalendarDayRepresentable] = [],
        range: ClosedRange<Date>? = nil,
        @ViewBuilder cell: @escaping (any CalendarDayRepresentable) -> Cell
    ) {
        self.init(days: days, range: range, cell: cell) {
            CalendarHeaderView()
        }
    }

    init<WeekdayLabel: View>(
        days: [any CalendarDayRepresentable] = [],
        range: ClosedRange<Date>? = nil,
        @ViewBuilder cell: @escaping (any CalendarDayRepresentable) -> Cell,
        @ViewBuilder weekdayLabel: @escaping (String) -> WeekdayLabel
    ) {
        self.init(days: days, range: range, cell: cell, header: {
            CalendarHeaderView()
        }, weekday: weekdayLabel)
    }
}
