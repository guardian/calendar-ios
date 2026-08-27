import SwiftUI

/// Shared layout metrics for the calendar grid.
enum CalendarLayout {
    static let cellHeight: CGFloat = 44
    static var gridHeight: CGFloat {
        6.0 * cellHeight // 6 cells in each column.
    }
}
