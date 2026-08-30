import Foundation

public struct CalendarMonthPickerCellContext {
    public let monthNumber: Int
    public let monthLabel: String
    public let monthDate: Date?
    public let isSelected: Bool
    public let isEnabled: Bool

    public init(
        monthNumber: Int,
        monthLabel: String,
        monthDate: Date?,
        isSelected: Bool,
        isEnabled: Bool
    ) {
        self.monthNumber = monthNumber
        self.monthLabel = monthLabel
        self.monthDate = monthDate
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
}
