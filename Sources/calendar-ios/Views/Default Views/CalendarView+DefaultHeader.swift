import SwiftUI

public extension CalendarView where Header == CalendarHeaderView {
    init(
        days: [any CalendarDayRepresentable] = [],
        range: ClosedRange<Date>? = nil,
        @ViewBuilder cell: @escaping (any CalendarDayRepresentable) -> Cell
    ) {
        self.init(days: days, range: range, cell: cell) { context in
            CalendarHeaderView(context: context)
        }
    }

    init<WeekdayLabel: View>(
        days: [any CalendarDayRepresentable] = [],
        range: ClosedRange<Date>? = nil,
        @ViewBuilder cell: @escaping (any CalendarDayRepresentable) -> Cell,
        @ViewBuilder weekdayLabel: @escaping (String) -> WeekdayLabel
    ) {
        self.init(days: days, range: range, cell: cell, header: { context in
            CalendarHeaderView(context: context)
        }, weekday: weekdayLabel)
    }
}
