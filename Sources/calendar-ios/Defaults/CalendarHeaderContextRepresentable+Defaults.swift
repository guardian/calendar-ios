import Foundation
import SwiftUI

private struct EmptyCalendarHeaderContext: CalendarHeaderContextRepresentable {
    let month: Date = .distantPast
    let canGoToPreviousMonth: Bool = false
    let canGoToNextMonth: Bool = false

    func changeMonth(by value: Int) { }
}

private struct CalendarHeaderContextKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any CalendarHeaderContextRepresentable = EmptyCalendarHeaderContext()
}

public extension EnvironmentValues {
    var calendarHeaderContext: any CalendarHeaderContextRepresentable {
        get { self[CalendarHeaderContextKey.self] }
        set { self[CalendarHeaderContextKey.self] = newValue }
    }
}
