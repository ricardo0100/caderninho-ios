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
    @Binding var filterType: FilterType
    
    var body: some View {
        HStack {
            Menu {
                ForEach(FilterType.allCases, id: \.self) { filterType in
                    Button {
                        withAnimation {
                            self.filterType = filterType
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
                    .frame(width: 24, height: 24)
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
                }.frame(height: 32)
            case .all:
                Text("Showing all transactions")
            default:
                Text("\(startDate.numericDate) - \(endDate.numericDate)")
            }
        }
    }
}

#Preview {
    @Previewable @State var startDate: Date = Date()
    @Previewable @State var endDate: Date = Date()
    @Previewable @State var filterType: FilterType = .all
    
    PeriodFilterView(startDate: $startDate, endDate: $endDate, filterType: $filterType)
}
