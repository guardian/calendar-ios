# mosaic-calendar-ios

A lightweight, customisable SwiftUI calendar for iOS. Supports custom day cells, custom headers, custom weekday labels, date-range constraints, and callbacks for month changes and day selection.

## Requirements

- iOS 18.0+
- Swift 6.0+
- Xcode 16+

## Installation

### Swift Package Manager

Add the package as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/guardian/mosaic-calendar-ios.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["calendar-ios"]
    )
]
```

Or in Xcode:

1. **File → Add Package Dependencies…**
2. Enter `https://github.com/guardian/mosaic-calendar-ios`
3. Choose your version rule and click **Add Package**.

## Core concepts

### `CalendarDayRepresentable`

Conform your day model to `CalendarDayRepresentable` to pass data into the calendar. The calendar sets `isToday` and `isSelected` on each value before passing it to your cell builder.

```swift
import calendar_ios

struct MyDay: CalendarDayRepresentable {
    var id: Date { date }
    let date: Date
    var isToday: Bool = false
    var isSelected: Bool = false
    // add any extra properties you need:
    var hasEvent: Bool = false
}
```

### `CalendarHeaderContextRepresentable`

Custom header views receive the current month state via the `\.calendarHeaderContext` environment key:

```swift
@Environment(\.calendarHeaderContext) private var context
// context.month               – the displayed month Date
// context.canGoToPreviousMonth
// context.canGoToNextMonth
// context.changeMonth(by:)    – call with +1 or -1
```

## Usage

Import the module:

```swift
import calendar_ios
```

### Minimal calendar

The simplest usage — just supply a cell builder:

```swift
CalendarView(days: myDays) { day in
    Text(day.date.formatted(.dateTime.day()))
        .foregroundStyle(day.isSelected ? .blue : day.isToday ? .orange : .primary)
}
```

### Limiting the visible date range

Pass a `ClosedRange<Date>` to restrict which months can be swiped to:

```swift
let range = Date.now...Date.now.addingTimeInterval(60 * 60 * 24 * 365)

CalendarView(days: myDays, range: range) { day in
    Text(day.date.formatted(.dateTime.day()))
}
```

### Using the built-in header

`CalendarHeaderView` shows the month name and previous/next chevrons. Add it via the `header:` parameter:

```swift
CalendarView(days: myDays) { day in
    DayCell(day: day)
} header: {
    CalendarHeaderView()
}
```

### Custom header

Supply any view in the `header:` closure and read `\.calendarHeaderContext` from the environment:

```swift
CalendarView(days: myDays) { day in
    DayCell(day: day)
} header: {
    MyHeaderView()
}

struct MyHeaderView: View {
    @Environment(\.calendarHeaderContext) private var context

    var body: some View {
        HStack {
            Button { context.changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left")
            }
            .disabled(!context.canGoToPreviousMonth)

            Spacer()

            Text(context.month.formatted(.dateTime.month(.wide).year()))
                .font(.headline)

            Spacer()

            Button { context.changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(!context.canGoToNextMonth)
        }
        .padding(.horizontal)
    }
}
```

### Custom weekday labels

Use the `weekday:` (or `weekdayLabel:`) parameter to style the Mon–Sun row:

```swift
CalendarView(days: myDays) { day in
    DayCell(day: day)
} weekday: { symbol in
    Text(symbol)
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
}
```

### Responding to user interactions

Chain the modifier methods to react to month navigation and day taps:

```swift
CalendarView(days: myDays) { day in
    DayCell(day: day)
}
.onMonthChange { interval in
    print("Visible month: \(interval)")
}
.onDateSelected { date, day in
    print("Tapped \(date), event: \(String(describing: day))")
}
```

### Full example

```swift
import SwiftUI
import calendar_ios

struct ContentView: View {
    let days: [MyDay] = [
        MyDay(date: .now, hasEvent: true),
        MyDay(date: .now.addingTimeInterval(86400 * 2), hasEvent: false)
    ]

    var body: some View {
        CalendarView(days: days) { day in
            VStack(spacing: 2) {
                Text(day.date.formatted(.dateTime.day()))
                    .fontWeight(day.isToday ? .bold : .regular)
                if let myDay = day as? MyDay, myDay.hasEvent {
                    Circle().fill(.accentColor).frame(width: 5, height: 5)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(day.isSelected ? Color.accentColor.opacity(0.2) : .clear)
        } header: {
            CalendarHeaderView()
        } weekday: { symbol in
            Text(symbol)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        }
        .onDateSelected { date, _ in
            print("Selected: \(date)")
        }
        .padding()
    }
}
```

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request.

Ensure your code compiles cleanly with Swift 6 strict concurrency before submitting.

## Licence

Distributed under the Apache 2.0 Licence. See [LICENCE](LICENSE) for more information.
