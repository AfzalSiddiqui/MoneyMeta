import CoreData
import SwiftUI

final class CategoryViewModel: ObservableObject {
    @Published var categories: [CDCategory] = []

    private let context: NSManagedObjectContext

    var expenseCategories: [CDCategory] {
        categories.filter { $0.wrappedCategoryType == .expense }
    }

    var incomeCategories: [CDCategory] {
        categories.filter { $0.wrappedCategoryType == .income }
    }

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
        fetchCategories()
    }

    func categories(for type: TransactionType) -> [CDCategory] {
        switch type {
        case .expense: return expenseCategories
        case .income: return incomeCategories
        }
    }

    func fetchCategories() {
        let request: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDCategory.categoryType, ascending: true),
            NSSortDescriptor(keyPath: \CDCategory.sortOrder, ascending: true)
        ]
        do {
            categories = try context.fetch(request)
        } catch {
            print("Fetch categories error: \(error)")
        }
    }

    func addCategory(name: String, colorHex: String, icon: String?, categoryType: CategoryType) {
        let category = CDCategory(context: context)
        category.id = UUID()
        category.name = name
        category.colorHex = colorHex
        category.icon = icon
        category.isDefault = false
        category.sortOrder = Int16(categories.count)
        category.wrappedCategoryType = categoryType
        category.createdAt = Date()
        save()
        fetchCategories()
    }

    func updateCategory(_ category: CDCategory, name: String, colorHex: String, icon: String?, categoryType: CategoryType) {
        category.name = name
        category.colorHex = colorHex
        category.icon = icon
        category.wrappedCategoryType = categoryType
        save()
        fetchCategories()
    }

    func deleteCategory(_ category: CDCategory) {
        context.delete(category)
        save()
        fetchCategories()
    }

    func canDelete(_ category: CDCategory) -> Bool {
        !category.isDefault
    }

    private func save() {
        CoreDataStack.shared.save()
    }
}
