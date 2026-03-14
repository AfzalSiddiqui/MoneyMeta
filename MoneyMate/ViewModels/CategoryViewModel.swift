import CoreData
import SwiftUI

final class CategoryViewModel: ObservableObject {
    @Published var categories: [CDCategory] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
        fetchCategories()
    }

    func fetchCategories() {
        let request: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDCategory.sortOrder, ascending: true)]
        do {
            categories = try context.fetch(request)
        } catch {
            print("Fetch categories error: \(error)")
        }
    }

    func addCategory(name: String, colorHex: String, icon: String?) {
        let category = CDCategory(context: context)
        category.id = UUID()
        category.name = name
        category.colorHex = colorHex
        category.icon = icon
        category.isDefault = false
        category.sortOrder = Int16(categories.count)
        category.createdAt = Date()
        save()
        fetchCategories()
    }

    func updateCategory(_ category: CDCategory, name: String, colorHex: String, icon: String?) {
        category.name = name
        category.colorHex = colorHex
        category.icon = icon
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
