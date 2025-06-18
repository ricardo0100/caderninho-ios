//
//  TransactionsPeriodFilterView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 25/05/25.
//

import SwiftUI

struct PeriodFilterView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State var filterType: FilterType = .last30Days
    
    func updateDateRange() {
        let range = filterType.dateRange
        startDate = range.start.firstSecondOfDay()
        endDate = range.end.lastSecondOfDay()
    }
    
    var body: some View {
        HStack {
            Menu {
                ForEach(FilterType.allCases, id: \.self) { filterType in
                    Button {
                        withAnimation {
                            self.filterType = filterType
                            if filterType != .custom {
                                updateDateRange()
                            }
                        }
                    } label: {
                        HStack {
                            Text(filterType.title)
                            if self.filterType == filterType {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "calendar.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(.systemBlue))
            }
            switch filterType {
            case .custom:
                HStack {
                    DatePicker("Start Date",
                               selection: $startDate,
                               displayedComponents: .date).labelsHidden()
                    DatePicker("End Date",
                               selection: $endDate,
                               displayedComponents: .date).labelsHidden()
                }
            default:
                Text(filterType.title)
            }
        }
        .onAppear {
            updateDateRange()
        }
    }
}

#Preview {
    @Previewable @State var startDate: Date = Date()
    @Previewable @State var endDate: Date = Date()
    
    PeriodFilterView(startDate: $startDate, endDate: $endDate)
}
