import SwiftUI

struct TransactionRowView: View {
    let transaction: CDTransaction

    var body: some View {
        HStack(spacing: 12) {
            CategoryIconView(
                colorHex: transaction.category?.wrappedColorHex ?? "#95A5A6",
                icon: transaction.category?.wrappedIcon ?? "ellipsis.circle.fill"
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.category?.wrappedName ?? "Uncategorized")
                    .font(.body)
                if !transaction.wrappedNote.isEmpty {
                    Text(transaction.wrappedNote)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(CurrencyFormatter.formatSigned(transaction.amount, type: transaction.transactionType))
                    .font(.body.weight(.medium))
                    .foregroundColor(transaction.transactionType == .income ? .green : .primary)
                Text(DateFormatters.shortDate.string(from: transaction.wrappedDate))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
