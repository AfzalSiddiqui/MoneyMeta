import SwiftUI

struct MonthlySummaryCard: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    viewModel.goToPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(viewModel.monthLabel)
                    .font(.headline)
                Spacer()
                Button {
                    viewModel.goToNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }

            HStack(spacing: 0) {
                SummaryItem(title: "Income", amount: viewModel.totalIncome, color: .green)
                Divider().frame(height: 40)
                SummaryItem(title: "Expenses", amount: viewModel.totalExpenses, color: .red)
                Divider().frame(height: 40)
                SummaryItem(title: "Balance", amount: viewModel.balance, color: viewModel.balance >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

private struct SummaryItem: View {
    let title: String
    let amount: Double
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(CurrencyFormatter.format(abs(amount)))
                .font(.subheadline.weight(.semibold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}
