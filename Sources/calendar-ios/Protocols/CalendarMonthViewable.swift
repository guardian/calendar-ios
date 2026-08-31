import SwiftUI

/// Marker protocol for custom month-picker cell views.
///
/// Conforming views must expose the month-picker context they render.
public protocol CalendarMonthViewable: View {
    var context: CalendarMonthPickerCellContext { get }
}
