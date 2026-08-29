import Foundation
import Observation

/// Read-only month state and actions exposed to custom calendar header views.
public protocol CalendarHeaderContextRepresentable: AnyObject, Observable {
    var month: Date { get }
    var canGoToPreviousMonth: Bool { get }
    var canGoToNextMonth: Bool { get }
    func changeMonth(by value: Int)
}
