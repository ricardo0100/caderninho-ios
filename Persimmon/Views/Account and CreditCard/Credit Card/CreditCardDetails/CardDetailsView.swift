//
//  CardDetailsView.swift
//  Persimmon
//
//  Created by Ricardo Gehrke Filho on 05/05/25.
//

import SwiftUI
import SwiftData

struct CardDetailsView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var card: CreditCard
    @EnvironmentObject var navigation: AccountsAndCardsNavigation
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.installments.sorted {
                    $0.number < $1.number
                }, id: \.self) { installment in
                    InstallmentCellView()
                        .environmentObject(installment)
                }
            } header: {
                VStack(alignment: .leading) {
                    BillSelectorView(selected: $viewModel.selectedBill, card: card)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Closing:")
                                Text(viewModel.selectedBill?.closingCycleDate.formatted(date: .abbreviated, time: .omitted) ?? "")
                                    .foregroundStyle(Color.primary)
                            }
                            HStack {
                                Text("Due:")
                                Text(viewModel.selectedBill?.dueDate.formatted(date: .abbreviated, time: .omitted) ?? "")
                                    .foregroundStyle(viewModel.selectedBill?.isDelayed == true ? Color.red : .primary)
                            }
                        }
                        Spacer()
                        if let date = viewModel.selectedBill?.payedDate {
                            Text("Paid in \(date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.footnote)
                                .onTapGesture(count: 2) {
                                    viewModel.didTapPayedDate()
                                }
                        } else {
                            Button("Set payed", action: viewModel.didTapSetPaid)
                                .buttonStyle(.bordered)
                        }
                    }
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets())
                .padding(.bottom)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    if let icon = card.icon {
                        Image(icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24)
                    } else {
                        LettersIconView(text: card.name.firstLetters(),
                                        color: Color(hex: card.color))
                    }
                    Text(card.name)
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .automatic) {
                Button("Edit") {
                    navigation.editingCard = card
                }
            }
        }
        .sheet(item: $navigation.editingCard) { card in
            EditCreditCardView(creditCard: card, context: modelContext, navigation: navigation)
        }
        .onAppear {
            // TODO: Move card to ViewModel
            viewModel.selectedBill = card.currentBill
        }
    }
}

#Preview {
    @Previewable @State var selected: Bill?
    let card = try! ModelContainer.preview.mainContext.fetch(FetchDescriptor<CreditCard>()).first!
    
    NavigationStack {
        CardDetailsView()
            .environmentObject(card)
    }
}
