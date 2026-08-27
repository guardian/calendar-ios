import SwiftUI

/// The grid of day cells for a single month.
@MainActor
struct CalendarMonthGridView<Cell: View>: View {
    let month: Date
    @Binding var selectedDate: Date?
    let daysByDate: [Date: any CalendarRepresentable]
    let cellContent: (any CalendarRepresentable) -> Cell
    let weekdayLabelContent: ((String) -> AnyView)?

    let columns = Array(
        repeating: GridItem(.flexible(), spacing: CalendarLayout.spacing),
        count: 7
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: CalendarLayout.spacing) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, date in
                Group {
                    if let date {
                        // The calendar owns selection; the cell only renders.
                        Button {
                            // Keep selection changes deterministic and avoid
                            // unintended layout animations in the surrounding pager.
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                selectedDate = date
                            }
                        } label: {
                            cellContent(representable(for: date))
                                .padding(.top, -0.5)
                        }
                        .buttonStyle(.plain)
                    } else {
                        // Empty leading slot for days before the 1st.
                        Color.clear
                            .frame(height: CalendarLayout.cellHeight)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .aspectRatio(1.0, contentMode: .fill)
            }
        }
        .safeAreaInset(edge: .top, spacing: CalendarLayout.spacing) {
            weekdayLabels
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    /// The caller-supplied day for a date (or a default), with the calendar's
    /// isToday/isSelected state applied.
    private func representable(for date: Date) -> any CalendarRepresentable {
        var day = daysByDate[date.beginningOfDay] ?? CalendarDay(date: date)
        day.isToday = date.isToday
        day.isSelected = selectedDate.map { $0.isSameDay(as: date) } ?? false
        return day
    }

    /// All cells for the month. nil entries pad the leading days before the 1st.
    private var days: [Date?] {
        let calendar: Calendar = .current
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))
        else { return [] }

        let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmptyCount = (weekdayOfFirst - calendar.firstWeekday + 7) % 7

        var cells: [Date?] = Array(repeating: nil, count: leadingEmptyCount)
        for day in range {
            cells.append(calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth))
        }
        return cells
    }
}
