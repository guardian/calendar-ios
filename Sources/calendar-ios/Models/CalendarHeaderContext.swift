import Foundation

public struct CalendarHeaderContext: CalendarHeaderContextRepresentable {
    public let month: Date
    public let canGoToPreviousMonth: Bool
    public let canGoToNextMonth: Bool
    private let changeMonthHandler: (Int) -> Void

    public init(
        month: Date,
        canGoToPreviousMonth: Bool,
        canGoToNextMonth: Bool,
        changeMonth: @escaping (Int) -> Void
    ) {
        self.month = month
        self.canGoToPreviousMonth = canGoToPreviousMonth
        self.canGoToNextMonth = canGoToNextMonth
        changeMonthHandler = changeMonth
    }

    public func changeMonth(by value: Int) {
        changeMonthHandler(value)
    }
}
