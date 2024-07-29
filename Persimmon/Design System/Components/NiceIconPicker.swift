//
//  IconPickerView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 28/07/24.
//

import SwiftUI

enum NiceIcon: String, CaseIterable {
    case health = "cross.fill"
    case rainbow = "rainbow"
    case dog = "dog.fill"
}

struct NiceIconPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selected: NiceIcon?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(NiceIcon.allCases, id: \.self) { icon in
                    ZStack {
                        if selected == icon {
                            Circle()
                                .fill(Color.brand)
                                .opacity(0.1)
                        }
                        Image(systemName: icon.rawValue)
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    .onTapGesture {
                        withAnimation {
                            self.selected = icon
                            dismiss()
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var selected: NiceIcon? = .rainbow
    NiceIconPicker(selected: $selected)
}
