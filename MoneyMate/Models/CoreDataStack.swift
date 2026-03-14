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

        let defaults: [(String, String, String)] = [
            ("Food", "#FF6B6B", "fork.knife"),
            ("Transport", "#4ECDC4", "car.fill"),
            ("Shopping", "#45B7D1", "bag.fill"),
            ("Bills", "#96CEB4", "doc.text.fill"),
            ("Entertainment", "#FFEAA7", "gamecontroller.fill"),
            ("Health", "#DDA0DD", "heart.fill"),
            ("Education", "#98D8C8", "book.fill"),
            ("Other", "#95A5A6", "ellipsis.circle.fill")
        ]

        for (index, item) in defaults.enumerated() {
            let category = CDCategory(context: viewContext)
            category.id = UUID()
            category.name = item.0
            category.colorHex = item.1
            category.icon = item.2
            category.isDefault = true
            category.sortOrder = Int16(index)
            category.createdAt = Date()
        }

        save()
    }
}
