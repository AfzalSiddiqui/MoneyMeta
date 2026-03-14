import CoreData
import SwiftUI

final class TransactionViewModel: ObservableObject {
    @Published var transactions: [CDTransaction] = []
    @Published var searchText: String = ""
    @Published var selectedType: TransactionType? = nil
    @Published var selectedCategory: CDCategory? = nil
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
        fetchTransactions()
    }

    var filteredTransactions: [CDTransaction] {
        var result = transactions

        if !searchText.isEmpty {
            result = result.filter {
                ($0.note ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.category?.name ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }

        if let type = selectedType {
            result = result.filter { $0.transactionType == type }
        }

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if let start = startDate {
            result = result.filter { ($0.date ?? Date()) >= start }
        }

        if let end = endDate {
            result = result.filter { ($0.date ?? Date()) <= end }
        }

        return result
    }

    var hasActiveFilters: Bool {
        selectedType != nil || selectedCategory != nil || startDate != nil || endDate != nil
    }

    func fetchTransactions() {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDTransaction.date, ascending: false)]
        do {
            transactions = try context.fetch(request)
        } catch {
            print("Fetch transactions error: \(error)")
        }
    }

    func addTransaction(amount: Double, type: TransactionType, note: String?, date: Date, category: CDCategory?) {
        let transaction = CDTransaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.transactionType = type
        transaction.note = note
        transaction.date = date
        transaction.category = category
        transaction.createdAt = Date()
        save()
        fetchTransactions()
    }

    func updateTransaction(_ transaction: CDTransaction, amount: Double, type: TransactionType, note: String?, date: Date, category: CDCategory?) {
        transaction.amount = amount
        transaction.transactionType = type
        transaction.note = note
        transaction.date = date
        transaction.category = category
        save()
        fetchTransactions()
    }

    func deleteTransaction(_ transaction: CDTransaction) {
        context.delete(transaction)
        save()
        fetchTransactions()
    }

    func deleteTransactions(at offsets: IndexSet) {
        let toDelete = offsets.map { filteredTransactions[$0] }
        toDelete.forEach { context.delete($0) }
        save()
        fetchTransactions()
    }

    func clearFilters() {
        selectedType = nil
        selectedCategory = nil
        startDate = nil
        endDate = nil
    }

    private func save() {
        CoreDataStack.shared.save()
    }
}
