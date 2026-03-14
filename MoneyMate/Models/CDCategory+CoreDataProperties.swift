import CoreData

enum CategoryType: Int16, CaseIterable {
    case expense = 0
    case income = 1

    var label: String {
        switch self {
        case .expense: return "Expense"
        case .income: return "Income"
        }
    }
}

extension CDCategory {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "CDCategory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var colorHex: String?
    @NSManaged public var icon: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var sortOrder: Int16
    @NSManaged public var categoryType: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var transactions: NSSet?

    var wrappedName: String { name ?? "Unknown" }
    var wrappedColorHex: String { colorHex ?? "#007AFF" }
    var wrappedIcon: String { icon ?? "ellipsis.circle.fill" }

    var wrappedCategoryType: CategoryType {
        get { CategoryType(rawValue: categoryType) ?? .expense }
        set { categoryType = newValue.rawValue }
    }

    var transactionArray: [CDTransaction] {
        let set = transactions as? Set<CDTransaction> ?? []
        return set.sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
    }
}

// MARK: - Generated accessors for transactions
extension CDCategory {
    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: CDTransaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: CDTransaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)
}

extension CDCategory: Identifiable {}
