import Foundation
import Observation

@Observable
public final class CalendarHeaderContext: CalendarHeaderContextRepresentable {
    public private(set) var month: Date
    public private(set) var canGoToPreviousMonth: Bool
    public private(set) var canGoToNextMonth: Bool
    var requestedMonthOffset: Int?

    public init(
        month: Date,
        canGoToPreviousMonth: Bool,
        canGoToNextMonth: Bool
    ) {
        self.month = month
        self.canGoToPreviousMonth = canGoToPreviousMonth
        self.canGoToNextMonth = canGoToNextMonth
    }

    public func changeMonth(by value: Int) {
        requestedMonthOffset = value
    }

    func apply(
        month: Date,
        canGoToPreviousMonth: Bool,
        canGoToNextMonth: Bool
    ) {
        self.month = month
        self.canGoToPreviousMonth = canGoToPreviousMonth
        self.canGoToNextMonth = canGoToNextMonth
    }

    func clearRequestedMonthOffset() {
        requestedMonthOffset = nil
    }
}
