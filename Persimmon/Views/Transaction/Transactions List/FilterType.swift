//
//  FilterView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/04/25.
//

import SwiftUI

enum FilterType: CaseIterable {
    case last30Days
    case lastWeek
    case today
    case yesterday
    case thisMonth
    case lastMonth
    case all
    case custom
    
    var title: String {
        switch self {
        case .last30Days:
            return "Last 30 days"
        case .lastWeek:
            return "Last week"
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
}
