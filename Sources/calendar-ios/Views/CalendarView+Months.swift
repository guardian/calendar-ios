import SwiftUI

extension MosaicCalendarView {

    func changeMonth(by value: Int) {
        guard let index = months.firstIndex(of: displayedMonth),
              months.indices.contains(index + value)
        else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            scrolledMonth = months[index + value]
        }
    }

    /// The first instant of the month containing `date`.
    func startOfMonth(for date: Date) -> Date {
        date.monthAndYear
    }

    /// The half-open date interval [firstOfMonth, firstOfNextMonth) for a month.
    func monthInterval(for month: Date) -> DateInterval {
        let start = startOfMonth(for: month)
        let end = start.adding(months: 1) ?? start
        return DateInterval(start: start, end: end)
    }

    static func makeVisibleMonths(calendar: Calendar, range: ClosedRange<Date>?, anchor: Date) -> [Date] {
        guard let range else {
            // Preserve existing behavior when no range is supplied.
            return (-2...2).map {
                calendar.date(byAdding: .month, value: $0, to: anchor) ?? anchor
            }
        }

        let lowerMonth = range.lowerBound.monthAndYear
        let upperMonth = range.upperBound.monthAndYear
        guard lowerMonth <= upperMonth else {
            return [anchor.monthAndYear]
        }

        let monthCount = calendar.dateComponents([.month], from: lowerMonth, to: upperMonth).month ?? 0
        return (0...monthCount).compactMap {
            calendar.date(byAdding: .month, value: $0, to: lowerMonth)
        }
    }

    static func initialMonth(for anchor: Date, in months: [Date]) -> Date {
        let normalizedAnchor = anchor.monthAndYear
        if months.contains(normalizedAnchor) {
            return normalizedAnchor
        }
        if let first = months.first, normalizedAnchor < first {
            return first
        }
        return months.last ?? normalizedAnchor
    }
}
