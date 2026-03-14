import Foundation

struct CurrencyFormatter {
    static let shared: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()

    static func format(_ amount: Double) -> String {
        shared.string(from: NSNumber(value: amount)) ?? "$0.00"
    }

    static func formatSigned(_ amount: Double, type: TransactionType) -> String {
        let prefix = type == .income ? "+" : "-"
        return "\(prefix)\(format(abs(amount)))"
    }
}
