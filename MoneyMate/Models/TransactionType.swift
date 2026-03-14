import Foundation

enum TransactionType: Int16, CaseIterable {
    case expense = 0
    case income = 1

    var label: String {
        switch self {
        case .expense: return "Expense"
        case .income: return "Income"
        }
    }
}
