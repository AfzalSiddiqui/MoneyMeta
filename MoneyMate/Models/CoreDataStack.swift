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
            ("Food", "#FF6B6B", "fork.knife"),
            ("Transport", "#4ECDC4", "car.fill"),
            ("Shopping", "#45B7D1", "bag.fill"),
            ("Bills", "#96CEB4", "doc.text.fill"),
            ("Entertainment", "#FFEAA7", "gamecontroller.fill"),
            ("Health", "#DDA0DD", "heart.fill"),
            ("Education", "#98D8C8", "book.fill"),
            ("EMI", "#FF8A80", "calendar.badge.clock"),
            ("Credit Card", "#7986CB", "creditcard.fill"),
            ("Other", "#95A5A6", "ellipsis.circle.fill")
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
            ("Salary", "#4CAF50", "banknote.fill"),
            ("Freelance", "#66BB6A", "laptopcomputer"),
            ("Investments", "#26A69A", "chart.line.uptrend.xyaxis"),
            ("Gifts", "#AB47BC", "gift.fill"),
            ("Refunds", "#42A5F5", "arrow.uturn.left.circle.fill"),
            ("Rental Income", "#8D6E63", "house.fill"),
            ("Other Income", "#78909C", "plus.circle.fill")
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
