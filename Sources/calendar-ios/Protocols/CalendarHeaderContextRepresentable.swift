import Foundation
import Observation

public enum CalendarHeaderDisplayMode {
    case month
    case year
}

/// Read-only month state and actions exposed to custom calendar header views.
public protocol CalendarHeaderContextRepresentable: AnyObject, Observable {
    var month: Date { get }
    var displayMode: CalendarHeaderDisplayMode { get }
    var pickerYear: Int { get }
    var canGoToPreviousMonth: Bool { get }
    var canGoToNextMonth: Bool { get }
    var canGoToPreviousYear: Bool { get }
    var canGoToNextYear: Bool { get }
    func changeMonth(by value: Int)
    func changeYear(by value: Int)
    func toggleDisplayMode()
    func showMonthView()
    func selectMonth(_ month: Date)
}
