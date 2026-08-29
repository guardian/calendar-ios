import SwiftUI

/// The calendar's month title and previous/next chevrons.
public struct CalendarHeaderView: View {
    let context: CalendarHeaderContext

    public init(context: CalendarHeaderContext) {
        self.context = context
    }

    public var body: some View {
        HStack {
            HStack(spacing: 16) {
                navigationButton(systemName: "chevron.left") {
                    if context.displayMode == .year {
                        context.changeYear(by: -1)
                    } else {
                        context.changeMonth(by: -1)
                    }
                }
                .disabled(isBackwardDisabled)
                .accessibilityLabel(context.displayMode == .year ? "Previous year" : "Previous month")
                Spacer()
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .dynamicTypeSize(.large ... .xxxLarge)
                    .contentTransition(.opacity)
                    .lineLimit(1)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        context.toggleDisplayMode()
                    }
                Spacer()
                navigationButton(systemName: "chevron.right") {
                    if context.displayMode == .year {
                        context.changeYear(by: 1)
                    } else {
                        context.changeMonth(by: 1)
                    }
                }
                .disabled(isForwardDisabled)
                .accessibilityLabel(context.displayMode == .year ? "Next year" : "Next month")
            }
        }
        .animation(.easeInOut(duration: 0.25), value: context.month)
    }

    private var title: String {
        if context.displayMode == .year {
            return String(context.pickerYear)
        }
        return context.month.formatted(.dateTime.month(.wide).year())
    }

    private var isBackwardDisabled: Bool {
        if context.displayMode == .year {
            return context.canGoToPreviousYear == false
        }
        return context.canGoToPreviousMonth == false
    }

    private var isForwardDisabled: Bool {
        if context.displayMode == .year {
            return context.canGoToNextYear == false
        }
        return context.canGoToNextMonth == false
    }

    private func navigationButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.body.weight(.semibold))
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.tint)
    }
}
