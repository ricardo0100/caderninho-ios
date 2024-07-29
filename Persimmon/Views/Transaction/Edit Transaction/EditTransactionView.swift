import SwiftUI
import Combine
import MapKit

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    private let transaction: Transaction?
    
    @State var name: String
    @State var nameError: String? = ""
    @State var account: Account?
    @State var accountError: String? = ""
    @State var value: Double
    @State var category: Category?
    @State var type: Transaction.TransactionType
    @State var date: Date
    @State var place: Transaction.Place?
    
    init(transaction: Transaction?) {
        self.transaction = transaction
        _name = State(initialValue: transaction?.name ?? "")
        _account = State(initialValue: transaction?.account)
        _value = State(initialValue: transaction?.value ?? .zero)
        _category = State(initialValue: transaction?.category)
        _type = State(initialValue: transaction?.type ?? .buyCredit)
        _date = State(initialValue: transaction?.date ?? Date())
        _place = State(initialValue: transaction?.place)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledView(labelText: "Name", error: $nameError) {
                        TextField("Transaction Name", text: $name)
                    }
                    
                    LabeledView(labelText: "Type") {
                        NavigationLink {
                            SelectTransactionTypeView(selectedType: $type)
                        } label: {
                            HStack(spacing: .spacingSmall) {
                                Image(systemName: type.iconName)
                                Text(type.text)
                            }
                        }
                    }
                    
                    LabeledView(labelText: "Account", error: $accountError) {
                        NavigationLink(destination: {
                            SelectAccountView(selected: $account)
                        }, label: {
                            if let account = account {
                                HStack(spacing: .spacingSmall) {
                                    LettersIconView(text: account.name.firstLetters(),
                                                    color: Color(hex: account.color),
                                                    size: 38)
                                    Text(account.name)
                                }
                            } else {
                                Text("Select account").foregroundColor(.secondary)
                            }
                        })
                    }
                    
                    LabeledView(labelText: "Value") {
                        CurrencyTextField(currency: account?.currency ?? "",
                                          value: $value,
                                          font: .title2)
                    }
                    
                    LabeledView(labelText: "Category") {
                        NavigationLink {
                            SelectCategoryView(selected: $category)
                        } label: {
                            if let category = category {
                                CategoryCell(category: category)
                            } else {
                                Text("Select category").foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    LabeledView(labelText: "Date and Time") {
                        let picker = SelectDateView(date: $date)
                        NavigationLink(destination: picker) {
                            VStack(alignment: .leading) {
                                Text(date.formatted(date: .complete, time: .omitted))
                                Text(date.formatted(date: .omitted, time: .shortened))
                            }.font(.footnote)
                        }
                    }
                    
                    LabeledView(labelText: "Location") {
                        NavigationLink {
                            SelectLocationView(place: $place)
                        } label: {
                            if let place = place {
                                VStack(alignment: .leading) {
                                    Text(place.name ?? "")
                                        .foregroundColor(.primary)
                                    if let subtitle = place.title {
                                        Text(subtitle).font(.footnote)
                                    }
                                }
                            } else {
                                Text("Select a Place")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Cancel", action: didTapCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: didTapSave)
                }
            }
        }
        .tint(.brand)
    }
    
    func didTapCancel() {
        dismiss()
    }
    
    func didTapSave() {
        withAnimation {
            clearErrors()
            guard !name.isEmpty else {
                nameError = "Mandatory field"
                return
            }
            guard account != nil else {
                accountError = "Select an account"
                return
            }
            saveTransaction()
        }
    }
    
    func clearErrors() {
        nameError = nil
        accountError = nil
    }
    
    func saveTransaction() {
        guard let account = account else {
            return
        }
        if let transaction = transaction {
            transaction.name = name
            transaction.account = account
            transaction.category = category
            transaction.value = value
            transaction.date = date
            transaction.place = place
        } else {
            let transaction = Transaction(
                id: UUID(),
                name: name,
                value: value,
                account: account,
                category: category,
                date: date,
                type: type,
                place: place)
            modelContext.insert(transaction)
        }
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss()
    }
}

#Preview {
    EditTransactionView(transaction: nil)
        .modelContainer(DataController.previewContainer)
}
