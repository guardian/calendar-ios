# calendar-ios

A lightweight Swift package for integrating a customisable calendar view into your iOS apps.

## Requirements

- iOS 18.0+
- Swift 6.0+
- Xcode 16+

## Installation

### Swift Package Manager

Add `calendar-ios` as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/guardian/calendar-ios.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["calendar-ios"]
    )
]
```

Or add it directly in Xcode:

1. Open your project in Xcode.
2. Go to **File → Add Package Dependencies…**
3. Enter the repository URL: `https://github.com/guardian/calendar-ios`
4. Select the version rule that suits you and click **Add Package**.

## Usage

Import the module wherever you need it:

```swift
import calendar_ios
```

### Basic Example

```swift
import SwiftUI
import calendar_ios

struct ContentView: View {
    @State private var selectedDate: Date = Date()

    var body: some View {
        CalendarView(selectedDate: $selectedDate)
            .padding()
    }
}
```

### Selecting a Date Range

```swift
import SwiftUI
import calendar_ios

struct RangePickerView: View {
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    var body: some View {
        CalendarView(startDate: $startDate, endDate: $endDate)
    }
}
```

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request.

Please make sure your code compiles cleanly with Swift 6 strict concurrency enabled before submitting.

## Licence

Distributed under the Apache 2.0 Licence. See [LICENCE](LICENSE) for more information.
