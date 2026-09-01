import SwiftUI

/// The grid of day cells for a single month.
@MainActor
struct CalendarMonthGridView<Cell: View>: View {

    // Month shown in this grid.
    let month: Date

    // Current selected date
    @Binding var selectedDate: Date?

    // Any custom data model mapped to this month's days.
    let daysByDate: [Date: any CalendarDayRepresentable]

    // View for each of the day cells in the grid.
    let cellContent: (any CalendarDayRepresentable) -> Cell

    // Optional view provided for each of the weekday labels above the grid.
    let weekdayLabelContent: ((String) -> AnyView)?

    /// Enables non-interactive Canvas-drawn grid decoration behind cells.
    let canvasDecorationsEnabled: Bool

    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 7
    )

    var body: some View {
        GeometryReader { proxy in
            Canvas { context, size in
                if canvasDecorationsEnabled {
                    drawDayCellBackgrounds(context: context, size: size, columns: 7)
                    drawGridLines(context: context, size: size, columns: 7, rows: dayRowCount)
                }
                drawDayCellContent(context: context, size: size, columns: 7)
            } symbols: {
                ForEach(Array(days.enumerated()), id: \.offset) { index, date in
                    if let date {
                        cellContent(representable(for: date))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .contentShape(Rectangle())
                            .tag(index)
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        selectDate(at: value.location, in: proxy.size, columns: 7)
                    }
            )
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            weekdayLabels
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    /// The caller-supplied day for a date (or a default), with the calendar's
    /// isToday/isSelected state applied.
    private func representable(for date: Date) -> any CalendarDayRepresentable {
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

    private var dayRowCount: Int {
        max(1, Int(ceil(Double(days.count) / 7.0)))
    }

    private func drawDayCellContent(context: GraphicsContext, size: CGSize, columns: Int) {
        guard columns > 0, size.width > 0, size.height > 0 else { return }

        let rows = dayRowCount
        guard rows > 0 else { return }

        let cellWidth = size.width / CGFloat(columns)
        let cellHeight = size.height / CGFloat(rows)

        for (index, maybeDate) in days.enumerated() {
            guard maybeDate != nil,
                  let symbol = context.resolveSymbol(id: index)
            else { continue }

            let row = index / columns
            let column = index % columns
            let rect = CGRect(
                x: CGFloat(column) * cellWidth,
                y: CGFloat(row) * cellHeight,
                width: cellWidth,
                height: cellHeight
            )

            context.draw(symbol, in: rect)
        }
    }

    // Paint cell state (selected/today) in a single canvas pass behind interactive content.
    private func drawDayCellBackgrounds(context: GraphicsContext, size: CGSize, columns: Int) {
        guard columns > 0, size.width > 0, size.height > 0 else { return }

        let rows = dayRowCount
        guard rows > 0 else { return }

        let cellWidth = size.width / CGFloat(columns)
        let cellHeight = size.height / CGFloat(rows)

        for (index, maybeDate) in days.enumerated() {
            guard let date = maybeDate else { continue }

            let day = representable(for: date)
            let row = index / columns
            let column = index % columns

            let x = CGFloat(column) * cellWidth
            let y = CGFloat(row) * cellHeight
            let baseRect = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let insetRect = baseRect.insetBy(dx: 3, dy: 3)

            if day.isSelected {
                context.fill(Path(roundedRect: insetRect, cornerRadius: 8), with: .color(Color.accentColor.opacity(0.2)))
            } else if day.isToday {
                context.fill(Path(roundedRect: insetRect, cornerRadius: 8), with: .color(Color.secondary.opacity(0.12)))
            }

            if day.isToday {
                context.stroke(
                    Path(roundedRect: insetRect, cornerRadius: 8),
                    with: .color(Color.accentColor.opacity(0.55)),
                    lineWidth: 1
                )
            }
        }
    }

    private func drawGridLines(context: GraphicsContext, size: CGSize, columns: Int, rows: Int) {
        guard columns > 0, rows > 0, size.width > 0, size.height > 0 else { return }

        let strokeColor = Color.secondary.opacity(0.12)
        let cellWidth = size.width / CGFloat(columns)
        let cellHeight = size.height / CGFloat(rows)

        for column in 1..<columns {
            let x = CGFloat(column) * cellWidth
            var path = Path()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            context.stroke(path, with: .color(strokeColor), lineWidth: 0.5)
        }

        for row in 1..<rows {
            let y = CGFloat(row) * cellHeight
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(path, with: .color(strokeColor), lineWidth: 0.5)
        }
    }

    private func selectDate(at point: CGPoint, in size: CGSize, columns: Int) {
        guard columns > 0, size.width > 0, size.height > 0 else { return }

        let rows = dayRowCount
        guard rows > 0 else { return }

        let cellWidth = size.width / CGFloat(columns)
        let cellHeight = size.height / CGFloat(rows)

        let clampedX = min(max(point.x, 0), max(0, size.width - 0.001))
        let clampedY = min(max(point.y, 0), max(0, size.height - 0.001))
        let column = Int(clampedX / cellWidth)
        let row = Int(clampedY / cellHeight)
        let index = row * columns + column

        guard index >= 0, index < days.count, let date = days[index] else { return }
        selectedDate = date
    }
}
