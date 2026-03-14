import CoreData
import SwiftUI

struct CategorySlice: Identifiable {
    let id = UUID()
    let categoryName: String
    let colorHex: String
    let amount: Double
    let percentage: Double
}

struct MonthlyBarData: Identifiable {
    let id = UUID()
    let month: String
    let income: Double
    let expense: Double
}

enum ChartPeriod: String, CaseIterable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"

    var monthCount: Int {
        switch self {
        case .threeMonths: return 3
        case .sixMonths: return 6
        case .oneYear: return 12
        }
    }
}

final class ChartViewModel: ObservableObject {
    @Published var categorySlices: [CategorySlice] = []
    @Published var monthlyData: [MonthlyBarData] = []
    @Published var selectedPeriod: ChartPeriod = .sixMonths
    @Published var currentMonth: Date = Date()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
        refresh()
    }

    func refresh() {
        fetchCategoryBreakdown()
        fetchMonthlyData()
    }

    private func fetchCategoryBreakdown() {
        let start = DateFormatters.startOfMonth(for: currentMonth)
        let end = DateFormatters.endOfMonth(for: currentMonth)

        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = NSPredicate(
            format: "date >= %@ AND date <= %@ AND type == %d",
            start as NSDate, end as NSDate, TransactionType.expense.rawValue
        )

        do {
            let transactions = try context.fetch(request)
            var categoryTotals: [String: (hex: String, total: Double)] = [:]

            for t in transactions {
                let name = t.category?.wrappedName ?? "Other"
                let hex = t.category?.wrappedColorHex ?? "#95A5A6"
                let existing = categoryTotals[name] ?? (hex: hex, total: 0)
                categoryTotals[name] = (hex: hex, total: existing.total + t.amount)
            }

            let grandTotal = categoryTotals.values.reduce(0) { $0 + $1.total }

            categorySlices = categoryTotals.map { name, data in
                CategorySlice(
                    categoryName: name,
                    colorHex: data.hex,
                    amount: data.total,
                    percentage: grandTotal > 0 ? (data.total / grandTotal) * 100 : 0
                )
            }.sorted { $0.amount > $1.amount }
        } catch {
            print("Category breakdown error: \(error)")
        }
    }

    private func fetchMonthlyData() {
        let calendar = Calendar.current
        var data: [MonthlyBarData] = []

        for i in (0..<selectedPeriod.monthCount).reversed() {
            guard let monthDate = calendar.date(byAdding: .month, value: -i, to: currentMonth) else { continue }
            let start = DateFormatters.startOfMonth(for: monthDate)
            let end = DateFormatters.endOfMonth(for: monthDate)

            let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)

            do {
                let transactions = try context.fetch(request)
                let income = transactions.filter { $0.transactionType == .income }.reduce(0) { $0 + $1.amount }
                let expense = transactions.filter { $0.transactionType == .expense }.reduce(0) { $0 + $1.amount }
                let label = DateFormatters.shortMonth.string(from: monthDate)
                data.append(MonthlyBarData(month: label, income: income, expense: expense))
            } catch {
                print("Monthly data error: \(error)")
            }
        }

        monthlyData = data
    }
}
