import SwiftUI

/// A single day in the calendar. Conformers supply the date;
/// the calendar fills in isToday/isSelected before handing the value
/// to a cell builder. The same type is used for input (days:) and for the cell.
public protocol CalendarRepresentable: Identifiable {
    var date: Date { get }
    var isToday: Bool { get set }
    var isSelected: Bool { get set }
}
