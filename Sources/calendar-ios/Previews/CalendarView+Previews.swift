import SwiftUI

private let previewDays: [PreviewCalendarDay] = [
    PreviewCalendarDay(date: .now, color: .blue),
    PreviewCalendarDay(date: .now.adding(days: 1)!, color: .green),
    PreviewCalendarDay(date: .now.adding(days: 3)!, color: .orange),
    PreviewCalendarDay(date: .now.adding(days: 5)!, color: .pink)
]

private let previewRange: ClosedRange<Date> =
Date.now.monthAndYear.adding(months: -2)!...Date.now.monthAndYear.adding(months: 1)!

#Preview("Custom Header + Weekday + Callbacks") {
    ScrollView {
        CalendarView(days: previewDays, range: previewRange) { day in
            PreviewDayCell(day: day)
        } header: {
            PreviewHeaderView()
                .border(.purple)
        } weekdayLabel: { symbol in
            PreviewWeekdayLabel(symbol: symbol)
        }
        .onDateSelected { _, _ in
            print("Date selected")
        }
        .onMonthChange { _ in
            print("Month changed")
        }
//        .border(.black)
    }
}

#Preview("Default Header") {
    ScrollView {
        CalendarView(days: previewDays) { day in
            PreviewDayCell(day: day)
        }
        .border(.black)
    }
}

#Preview("Default Header + Weekday Labels") {
    ScrollView {
        CalendarView(days: previewDays) { day in
            PreviewDayCell(day: day)
        } weekdayLabel: { symbol in
            PreviewWeekdayLabel(symbol: symbol)
        }
        .border(.black)
    }
}

#Preview("Custom Header") {
    ScrollView {
        CalendarView(days: previewDays) { day in
            PreviewDayCell(day: day)
        } header: {
            PreviewHeaderView()
        }
        .border(.black)
    }
}

private struct PreviewWeekdayLabel: View {
    let symbol: String

    var body: some View {
        Text(symbol)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct PreviewHeaderView: View {
    @Environment(\.calendarHeaderContext) private var context

    var body: some View {
        HStack {
            Button {
                context.changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(context.canGoToPreviousMonth == false)

            Spacer()

            Text(context.month.formatted(.dateTime.month(.wide).year()))
                .font(.headline)

            Spacer()

            Button {
                context.changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(context.canGoToNextMonth == false)
        }
        .dynamicTypeSize(.large ... .accessibility1)
    }
}

private struct PreviewDayCell: View {
    let day: any CalendarDayRepresentable

    var previewDay: PreviewCalendarDay? {
        return day as? PreviewCalendarDay
    }
    
    var body: some View {
        Text(day.date.formatted(.dateTime.day()))
            .font(day.isToday ? .body : .subheadline)
            .dynamicTypeSize(.large ... .accessibility1)
            .fontWeight(day.isToday ? .black : .regular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(day.isSelected ? Color.white : previewDay?.color ?? Color.primary)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.black)
                    .opacity(day.isSelected ? 1 : 0)
            }
            .overlay {
                Rectangle()
                    .stroke(.gray)
            }
            .contentShape(Rectangle())
            .accessibilityLabel(accessibilityLabel)
            .accessibilityAddTraits(day.isSelected ? [.isSelected] : [])
    }

    private var accessibilityLabel: String {
        let base = day.date.formatted(.dateTime.weekday(.wide).month(.wide).day())
        return day.isToday ? "\(base), Today" : base
    }
}

private struct PreviewCalendarDay: CalendarDayRepresentable {
    var id: Date { date }
    let date: Date
    var color: Color?
    var isToday: Bool = false
    var isSelected: Bool = false
}
