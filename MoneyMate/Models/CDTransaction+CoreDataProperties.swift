import CoreData

extension CDTransaction {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTransaction> {
        return NSFetchRequest<CDTransaction>(entityName: "CDTransaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var amount: Double
    @NSManaged public var type: Int16
    @NSManaged public var note: String?
    @NSManaged public var date: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var category: CDCategory?

    var wrappedNote: String { note ?? "" }
    var wrappedDate: Date { date ?? Date() }

    var transactionType: TransactionType {
        get { TransactionType(rawValue: type) ?? .expense }
        set { type = newValue.rawValue }
    }
}

extension CDTransaction: Identifiable {}
