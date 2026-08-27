import SwiftUI

/// Shared layout metrics for the calendar grid.
enum CalendarLayout {
    static let cellHeight: CGFloat = 44
    static let spacing: CGFloat = 0
    static let rowCount = 6

    static var gridHeight: CGFloat {
        CGFloat(rowCount) * cellHeight + CGFloat(rowCount - 1) * spacing
    }
}
