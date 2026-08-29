import SwiftUI

extension MosaicCalendarView {

    /// A compact 3x4 month grid used when the header enters month-picker mode.
    var monthPicker: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

        return VStack(spacing: 12) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(1...12, id: \.self) { monthNumber in
                    monthPickerButton(monthNumber: monthNumber)
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }

    private func monthPickerButton(monthNumber: Int) -> some View {
        let calendar = Calendar.current
        let symbols = calendar.shortMonthSymbols
        let monthLabel = symbols[max(0, min(symbols.count - 1, monthNumber - 1))]
        let monthDate = calendar.date(from: DateComponents(year: headerContext.pickerYear, month: monthNumber, day: 1))?.monthAndYear
        let isEnabled = monthDate.map { months.contains($0) } ?? false
        let isSelected = monthDate.map { calendar.isDate($0, equalTo: displayedMonth, toGranularity: .month) } ?? false

        return Button {
            guard let monthDate else { return }
            headerContext.selectMonth(monthDate)
        } label: {
            Text(monthLabel)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.12))
                }
        }
        .buttonStyle(.plain)
        .disabled(isEnabled == false)
        .opacity(isEnabled ? 1 : 0.35)
        .accessibilityLabel(monthLabel)
    }
}
