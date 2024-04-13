import Foundation

extension Date {
    static func yesterday() -> Date {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar = Calendar.current
        return calendar.date(byAdding: dayComponent, to: Date())!
    }
}
