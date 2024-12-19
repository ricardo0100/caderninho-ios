import SwiftUI
import CoreData

struct EditAccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var account: Account?
    @State var isShowingColorPicker = false
    @State var name = ""
    @State var nameErrorMessage: String?
    @State var currency = ""
    @State var currencyErroMessage: String?
    @State var niceColor: NiceColor = .gray
    @State var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                LabeledView(labelText: "Name", error: $nameErrorMessage) {
                    TextField("Account name", text: $name)
                }
                LabeledView(labelText: "Currency", error: $currencyErroMessage) {
                    TextField("$", text: $currency)
                }
                LabeledView(labelText: "Color") {
                    Circle()
                        .fill()
                        .foregroundColor(niceColor.color)
                        .frame(width: 20, height: 20)
                }.onTapGesture {
                    isShowingColorPicker = true
                }
                if account != nil {
                    Section {
                        Button("Delete account") {
                            showDeleteAlert = true
                        }.tint(.red)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: didTapSave)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: didTapCancel)
                }
            }
            .sheet(isPresented: $isShowingColorPicker) {
                NiceColorPicker(selected: $niceColor).padding()
            }
            .confirmationDialog("Delete?", isPresented: $showDeleteAlert, actions: {
                Button("Delete") {
                    guard let account else { return }
                    modelContext.delete(account)
                    try? modelContext.save()
                    dismiss()
                }.tint(.red)
                Button("Cancel") {
                    showDeleteAlert = false
                }
            })
        }.onAppear {
            guard let account = account else { return }
            name = account.name
            currency = account.currency
            niceColor = NiceColor(rawValue: account.color) ?? .gray
        }
    }
    
    private func validate() -> Bool {
        nameErrorMessage = name.count > .zero ? nil : "Campo obrigatório"
        currencyErroMessage = currency.count > .zero ? nil : "Campo obrigatório"
        return nameErrorMessage == nil && currencyErroMessage == nil
    }
    
    private func didTapSave() {
        guard validate() else { return }
        if let account = account {
            account.name = name
            account.currency = currency
            account.color = niceColor.rawValue
        } else {
            let account = Account(id: UUID(),
                                  name: name,
                                  color: niceColor.rawValue,
                                  currency: currency)
            modelContext.insert(account)
        }
        withAnimation {
            try? modelContext.save()
            dismiss()
        }
    }
    
    private func didTapCancel() {
        dismiss()
    }
}

#Preview {
    EditAccountView(account: nil)
}
