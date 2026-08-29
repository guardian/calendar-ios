import Foundation
import Observation
import SwiftUI

@Observable
private final class EmptyCalendarHeaderContext: CalendarHeaderContextRepresentable {
    let month: Date = .distantPast
    let displayMode: CalendarHeaderDisplayMode = .month
    let pickerYear: Int = Calendar.current.component(.year, from: .distantPast)
    let canGoToPreviousMonth: Bool = false
    let canGoToNextMonth: Bool = false
    let canGoToPreviousYear: Bool = false
    let canGoToNextYear: Bool = false

    func changeMonth(by value: Int) { }
    func changeYear(by value: Int) { }
    func toggleDisplayMode() { }
    func showMonthView() { }
    func selectMonth(_ month: Date) { }
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
