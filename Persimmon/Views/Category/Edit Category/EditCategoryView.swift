import SwiftUI

struct EditCategoryView: View {
    @EnvironmentObject var navigation: NavigationModel
    @Environment(\.modelContext) var modelContext
    
    var category: Category?
    @State var name: String = ""
    @State var nameErrorMessage: String?
    @State var isShowingColorPicker = false
    @State var isShowingIconPicker = false
    @State var niceColor: NiceColor = .gray
    @State var niceIcon: NiceIcon? = nil
    @State var showDeleteAlert = false
    
    init(category: Category? = nil) {
        self.category = category
        if let category = category {
            _name = State(initialValue: category.name)
            _niceIcon = State(initialValue: .init(rawValue: category.icon ?? "") ?? nil)
            _niceColor = State(initialValue: NiceColor(rawValue: category.color) ?? .darkGray)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                LabeledView(labelText: "Name", error: $nameErrorMessage) {
                    TextField("Category name", text: $name)
                }
                LabeledView(labelText: "Color") {
                    Circle()
                        .fill()
                        .foregroundColor(niceColor.color)
                        .frame(width: 20, height: 20)
                }.onTapGesture {
                    isShowingColorPicker = true
                }
                LabeledView(labelText: "Icon") {
                    if let icon = niceIcon {
                        Image(systemName: icon.rawValue)
                            .foregroundStyle(niceColor.color)
                    } else {
                        Text("Select Icon")
                            .foregroundStyle(.secondary)
                    }
                }.onTapGesture {
                    isShowingIconPicker = true
                }
                if category != nil {
                    Section {
                        Button("Delete category") {
                            showDeleteAlert = true
                        }.tint(.red)
                    }
                }
            }
            .sheet(isPresented: $isShowingColorPicker) {
                NavigationStack {
                    NiceColorPicker(selected: $niceColor)
                }
            }
            .sheet(isPresented: $isShowingIconPicker) {
                NavigationStack {
                    NiceIconPicker(selected: $niceIcon)
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
            .confirmationDialog("Delete?", isPresented: $showDeleteAlert, actions: {
                Button("Delete", role: .destructive) {
                    guard let category else { return }
                    modelContext.delete(category)
                    try? modelContext.save()
                    navigation.categoriesPath.removeLast()
                    navigation.editingCategory = nil
                }.tint(.red)
                Button("Cancel") {
                    showDeleteAlert = false
                }
            })
            .onAppear {
                if let category = category {
                    name = category.name
                    niceColor = NiceColor(rawValue: category.color) ?? .gray
                    if let icon = category.icon {
                        niceIcon = NiceIcon(rawValue: icon)
                    }
                }
            }
        }
        .tint(.brand)
    }
    
    private func validate() -> Bool {
        nameErrorMessage = name.count > .zero ? nil : "Mandatory field"
        return nameErrorMessage == nil
    }
    
    private func didTapSave() {
        guard validate() else { return }
        if let category = category {
            category.name = name
            category.color = niceColor.rawValue
            category.icon = niceIcon?.rawValue
        } else {
            let category = Category(id: UUID(),
                                    name: name,
                                    color: niceColor.rawValue,
                                    icon: niceIcon?.rawValue)
            modelContext.insert(category)
        }
        try? modelContext.save()
        navigation.editingCategory = nil
        navigation.newCategory = false
    }
    
    func didTapCancel() {
        navigation.newCategory = false
        navigation.editingCategory = nil
    }
}

#Preview {
    NavigationStack {
        EditCategoryView()
    }
}
