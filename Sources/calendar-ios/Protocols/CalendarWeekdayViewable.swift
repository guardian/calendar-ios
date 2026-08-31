import SwiftUI

/// Marker protocol for custom weekday label views.
///
/// Conforming views must expose the weekday symbol they render.
public protocol CalendarWeekdayViewable: View {
    var symbol: String { get }
}
