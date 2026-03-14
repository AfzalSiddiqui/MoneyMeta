import SwiftUI

struct RecentTransactionsView: View {
    let transactions: [CDTransaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                Spacer()
            }

            if transactions.isEmpty {
                Text("No transactions yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
            } else {
                ForEach(transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                    if transaction.id != transactions.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
