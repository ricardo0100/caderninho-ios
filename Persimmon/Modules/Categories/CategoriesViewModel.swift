import Foundation

struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let color: NiceColor
    let icon: String
    let total: Double
}

protocol CategoriesViewModelProtocol: ObservableObject {
    var categories: [CategoryItem] { get }
    func fetchCategories()
}

class CategoriesViewModelMock: CategoriesViewModelProtocol {
    static var availableCategories: [CategoryItem] = [
        CategoryItem(name: "House", color: NiceColor.red, icon: "house.fill", total: 2.92),
        CategoryItem(name: "Food", color: NiceColor.green, icon: "fork.knife", total: 19.1),
        CategoryItem(name: "Travel", color: NiceColor.blue, icon: "car.fill", total: 9.94),
        CategoryItem(name: "Entertainment", color: NiceColor.orange, icon: "popcorn.fill", total: 1229.9),
        CategoryItem(name: "Education", color: NiceColor.chocolate, icon: "books.vertical.fill", total: 99.99),
        CategoryItem(name: "Health", color: NiceColor.yellow, icon: "heart.fill", total: 19.9),
        CategoryItem(name: "Shopping", color: NiceColor.teal, icon: "cart.fill", total: 22.9)
    ]

    
    @Published var categories: [CategoryItem] = []

    init() {
        fetchCategories()
    }

    func fetchCategories() {
        self.categories = Self.availableCategories
    }
}
