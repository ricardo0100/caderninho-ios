//
//  FilterView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 27/04/25.
//

import SwiftUI

enum FilterType: CaseIterable {
    case last30Days
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
            return "Custom"
        }
    }
}

struct FilterView: View {
    @Binding var selectedFilter: FilterType
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State var isShowingStartPicker = false
    @State var isShowingEndPicker = false
    
    var body: some View {
        VStack {
            Picker(selection: $selectedFilter) {
                ForEach(FilterType.allCases, id: \.self) {
                    Text($0.title)
                }
            } label: {
                Text("Period:").foregroundStyle(.gray)
            }
            
            if selectedFilter == .custom {
                HStack {
                    LabeledView(labelText: "Start Date") {
                        Button(Date.dateFormatter.string(from: startDate)) {
                            isShowingStartPicker = true
                        }.buttonStyle(PlainButtonStyle()).font(.footnote)
                    }
                    Spacer()
                    LabeledView(labelText: "End Date", alignRight: true) {
                        Button(Date.dateFormatter.string(from: endDate)) {
                            isShowingEndPicker = true
                        }.buttonStyle(PlainButtonStyle()).font(.footnote)
                    }
                }
            }
        }
        .popover(isPresented: $isShowingStartPicker) {
            SelectDateView(isShowing: $isShowingStartPicker, date: $startDate)
        }
        .popover(isPresented: $isShowingEndPicker) {
            SelectDateView(isShowing: $isShowingEndPicker, date: $endDate)
        }
    }
}

#Preview {
    @Previewable @State var startDate = Date()
    @Previewable @State var endDate = Date()
    @Previewable @State var filter: FilterType = .custom
    
    List {
        FilterView(selectedFilter: $filter,
                   startDate: $startDate,
                   endDate: $endDate)
    }
}
