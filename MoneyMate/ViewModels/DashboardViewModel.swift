import CoreData
import SwiftUI

final class DashboardViewModel: ObservableObject {
    @Published var totalIncome: Double = 0
    @Published var totalExpenses: Double = 0
    @Published var recentTransactions: [CDTransaction] = []
    @Published var currentMonth: Date = Date()

    private let context: NSManagedObjectContext

    var balance: Double {
        totalIncome - totalExpenses
    }

    var monthLabel: String {
        DateFormatters.monthYear.string(from: currentMonth)
    }

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
        refresh()
    }

    func refresh() {
        fetchMonthlySummary()
        fetchRecentTransactions()
    }

    func goToPreviousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newDate
            refresh()
        }
    }

    func goToNextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newDate
            refresh()
        }
    }

    private func fetchMonthlySummary() {
        let start = DateFormatters.startOfMonth(for: currentMonth)
        let end = DateFormatters.endOfMonth(for: currentMonth)

        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)

        do {
            let transactions = try context.fetch(request)
            totalIncome = transactions.filter { $0.transactionType == .income }.reduce(0) { $0 + $1.amount }
            totalExpenses = transactions.filter { $0.transactionType == .expense }.reduce(0) { $0 + $1.amount }
        } catch {
            print("Dashboard fetch error: \(error)")
        }
    }

    private func fetchRecentTransactions() {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDTransaction.date, ascending: false)]
        request.fetchLimit = 5
        do {
            recentTransactions = try context.fetch(request)
        } catch {
            print("Recent transactions fetch error: \(error)")
        }
    }
}
