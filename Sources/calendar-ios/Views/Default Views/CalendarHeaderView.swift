import SwiftUI

/// The calendar's month title and previous/next chevrons.
public struct CalendarHeaderView: View {
    @Environment(\.calendarHeaderContext) private var context

    public init() {}

    public var body: some View {
        HStack {
            HStack(spacing: 16) {
                navigationButton(systemName: "chevron.left") {
                    context.changeMonth(by: -1)
                }
                .disabled(context.canGoToPreviousMonth == false)
                .accessibilityLabel("Previous month")
                Spacer()
                Text(context.month.formatted(.dateTime.month(.wide).year()))
                    .font(.subheadline.weight(.semibold))
                    .dynamicTypeSize(.large ... .xxxLarge)
                    .contentTransition(.opacity)
                    .lineLimit(1)
                Spacer()
                navigationButton(systemName: "chevron.right") {
                    context.changeMonth(by: 1)
                }
                .disabled(context.canGoToNextMonth == false)
                .accessibilityLabel("Next month")
            }
        }
        .animation(.easeInOut(duration: 0.25), value: context.month)
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
