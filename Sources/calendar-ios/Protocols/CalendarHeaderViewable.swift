import SwiftUI

/// Marker protocol for header views used by `MosaicCalendarView`.
///
/// Conforming views must expose the current header context.
public protocol CalendarHeaderViewable: View {
    var context: any CalendarHeaderContextRepresentable { get }
}
