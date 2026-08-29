import Foundation
import Observation

@Observable
public final class CalendarHeaderContext: CalendarHeaderContextRepresentable {
    public private(set) var displayMode: CalendarHeaderDisplayMode
    public private(set) var month: Date
    public private(set) var pickerYear: Int
    public private(set) var canGoToPreviousMonth: Bool
    public private(set) var canGoToNextMonth: Bool
    public private(set) var canGoToPreviousYear: Bool
    public private(set) var canGoToNextYear: Bool

    private let minimumVisibleYear: Int
    private let maximumVisibleYear: Int

    var requestedMonthOffset: Int?
    var requestedMonthSelection: Date?

    public init(
        month: Date,
        canGoToPreviousMonth: Bool,
        canGoToNextMonth: Bool,
        minimumVisibleYear: Int,
        maximumVisibleYear: Int
    ) {
        let year = Calendar.current.component(.year, from: month)
        self.displayMode = .month
        self.month = month
        self.pickerYear = year
        self.canGoToPreviousMonth = canGoToPreviousMonth
        self.canGoToNextMonth = canGoToNextMonth
        self.minimumVisibleYear = min(minimumVisibleYear, maximumVisibleYear)
        self.maximumVisibleYear = max(minimumVisibleYear, maximumVisibleYear)
        self.canGoToPreviousYear = year > self.minimumVisibleYear
        self.canGoToNextYear = year < self.maximumVisibleYear
    }

    public func changeMonth(by value: Int) {
        requestedMonthOffset = value
    }

    public func changeYear(by value: Int) {
        let nextYear = pickerYear + value
        guard nextYear >= minimumVisibleYear, nextYear <= maximumVisibleYear else { return }
        pickerYear = nextYear
        updateYearNavigationAvailability()
    }

    public func toggleDisplayMode() {
        switch displayMode {
        case .month:
            displayMode = .year
            pickerYear = Calendar.current.component(.year, from: month)
            updateYearNavigationAvailability()
        case .year:
            displayMode = .month
        }
    }

    public func showMonthView() {
        displayMode = .month
    }

    public func selectMonth(_ month: Date) {
        requestedMonthSelection = month.monthAndYear
        displayMode = .month
    }

    func apply(
        month: Date,
        canGoToPreviousMonth: Bool,
        canGoToNextMonth: Bool
    ) {
        self.month = month
        self.canGoToPreviousMonth = canGoToPreviousMonth
        self.canGoToNextMonth = canGoToNextMonth

        if displayMode == .month {
            pickerYear = Calendar.current.component(.year, from: month)
            updateYearNavigationAvailability()
        }
    }

    func clearRequestedMonthOffset() {
        requestedMonthOffset = nil
    }

    func clearRequestedMonthSelection() {
        requestedMonthSelection = nil
    }

    private func updateYearNavigationAvailability() {
        canGoToPreviousYear = pickerYear > minimumVisibleYear
        canGoToNextYear = pickerYear < maximumVisibleYear
    }
}
