import Foundation

extension Date {
    var day: Int {
        Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
    
    var month: Int {
        Calendar.current.dateComponents([.month], from: self).month ?? 0
    }
    
    var year: Int {
        Calendar.current.dateComponents([.year], from: self).year ?? 0
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static func yesterday() -> Date {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar = Calendar.current
        return calendar.date(byAdding: dayComponent, to: Date())!
    }

    static func getTodayBounds() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        return (start: startOfToday, end: now)
    }
    
    static func getYesterdayBounds() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now) ?? Date()
        let startOfYesterday = calendar.startOfDay(for: yesterday)
        var components = DateComponents()
        components.day = 0
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endOfYesterday = calendar.date(byAdding: components, to: startOfYesterday)!
        
        return (start: startOfYesterday, end: endOfYesterday)
    }

    static func getThisMonthBounds() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        var components = DateComponents()
        components.month = 1
        components.second = -1
        let endOfMonth = calendar.date(byAdding: components, to: startOfMonth)!
        return (start: startOfMonth, end: endOfMonth)
    }
    
    static func getLastMonthBounds() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let startOfThisMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfLastMonth = calendar.date(byAdding: .second, value: -1, to: startOfThisMonth)!
        let startOfLastMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: endOfLastMonth))!
        return (start: startOfLastMonth, end: endOfLastMonth)
    }
    
    static func getLast30DaysBounds() -> (start: Date, end: Date) {
        let end = Date()
        let start = end.dateAddingDays(-30)
        return (start: start, end: end)
    }
    
    func dateAddingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func dateAddingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    static func shortMonthName(from monthNumber: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.shortMonthSymbols[monthNumber - 1]
    }
}
