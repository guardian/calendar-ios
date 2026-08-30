import SwiftUI

/// Marker protocol for day-cell views used by `MosaicCalendarView`.
///
/// Conforming views must expose the currently rendered day model.
public protocol CalendarDayViewable: View {
    var day: any CalendarDayRepresentable { get }
}
