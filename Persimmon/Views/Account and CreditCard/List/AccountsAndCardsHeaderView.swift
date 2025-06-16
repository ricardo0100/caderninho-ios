//
//  AccountsAndCardsHeaderView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 16/06/25.
//

import SwiftUI
import SwiftData


struct AccountsAndCardsHeaderView: View {
    enum Option: LocalizedStringKey, CaseIterable, Identifiable {
        case distribution = "Distribution"
        case evoution = "Evolution"

        var id: Self { self }
    }

    @State private var selectedSegment: Option = .distribution
    
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedSegment) {
                ForEach(Option.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            switch selectedSegment {
            case .distribution:
                AccountsDistributionGraphView()
                    .frame(height: 80)
            case .evoution:
                Text("⚠️ Soon")
            }
        }
    }
}
