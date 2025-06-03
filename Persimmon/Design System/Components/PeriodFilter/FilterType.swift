//
//  FilterView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/04/25.
//

import SwiftUI

enum FilterType: CaseIterable {
    case last30Days
    case last7Days
    case today
    case yesterday
    case thisMonth
    case lastMonth
    case all
    case custom
    
    var title: LocalizedStringKey {
        switch self {
        case .last30Days:
            return "Last 30 days"
        case .last7Days:
            return "Last 7 days"
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .thisMonth:
            return "This month"
        case .lastMonth:
            return "Last month"
        case .all:
            return "All"
        case .custom:
            return "Custom period"
        }
    }
    
    var dateRange: (start: Date, end: Date) {
        switch self {
        case .last30Days:
            return Date.getLast30DaysBounds()
        case .last7Days:
            return Date.getLast7DaysBounds()
        case .today:
            return Date.getTodayBounds()
        case .yesterday:
            return Date.getYesterdayBounds()
        case .thisMonth:
            return Date.getThisMonthBounds()
        case .lastMonth:
            return Date.getLastMonthBounds()
        case .all:
            return (Date.distantPast, Date.distantFuture)
        case .custom:
            return (Date.distantPast, Date.distantFuture)
        }
    }
}
