import CoreData

final class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "MoneyMate")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data load error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func save() {
        let context = viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Core Data save error: \(nsError), \(nsError.userInfo)")
        }
    }

    func seedDefaultCategories() {
        let request: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
        let count = (try? viewContext.count(for: request)) ?? 0
        guard count == 0 else { return }

        // Expense categories
        let expenses: [(String, String, String)] = [
            ("Food", "#FB7185", "fork.knife"),
            ("Transport", "#06B6D4", "car.fill"),
            ("Shopping", "#8B5CF6", "bag.fill"),
            ("Bills", "#64748B", "doc.text.fill"),
            ("Entertainment", "#F59E0B", "gamecontroller.fill"),
            ("Health", "#EC4899", "heart.fill"),
            ("Education", "#3B82F6", "book.fill"),
            ("EMI", "#F97316", "calendar.badge.clock"),
            ("Credit Card", "#6366F1", "creditcard.fill"),
            ("Other", "#94A3B8", "ellipsis.circle.fill")
        ]

        for (index, item) in expenses.enumerated() {
            let category = CDCategory(context: viewContext)
            category.id = UUID()
            category.name = item.0
            category.colorHex = item.1
            category.icon = item.2
            category.isDefault = true
            category.sortOrder = Int16(index)
            category.categoryType = CategoryType.expense.rawValue
            category.createdAt = Date()
        }

        // Income categories
        let incomes: [(String, String, String)] = [
            ("Salary", "#10B981", "banknote.fill"),
            ("Freelance", "#14B8A6", "laptopcomputer"),
            ("Investments", "#0EA5E9", "chart.line.uptrend.xyaxis"),
            ("Gifts", "#A855F7", "gift.fill"),
            ("Refunds", "#06B6D4", "arrow.uturn.left.circle.fill"),
            ("Rental Income", "#D4A574", "house.fill"),
            ("Other Income", "#64748B", "plus.circle.fill")
        ]

        for (index, item) in incomes.enumerated() {
            let category = CDCategory(context: viewContext)
            category.id = UUID()
            category.name = item.0
            category.colorHex = item.1
            category.icon = item.2
            category.isDefault = true
            category.sortOrder = Int16(index)
            category.categoryType = CategoryType.income.rawValue
            category.createdAt = Date()
        }

        save()
    }
}
