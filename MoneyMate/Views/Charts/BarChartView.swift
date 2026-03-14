import SwiftUI
import Charts

struct BarChartView: View {
    let data: [MonthlyBarData]
    @Binding var period: ChartPeriod

    var body: some View {
        VStack(spacing: 12) {
            Text("Income vs Expenses")
                .font(.headline)

            ChartPeriodPicker(selection: $period)

            if data.isEmpty || data.allSatisfy({ $0.income == 0 && $0.expense == 0 }) {
                EmptyStateView(
                    icon: "chart.bar",
                    title: "No Data",
                    message: "Add transactions to see your trends."
                )
            } else {
                if #available(iOS 16.0, *) {
                    SwiftUIBarChart(data: data)
                        .frame(height: 200)
                } else {
                    FallbackBarChart(data: data)
                        .frame(height: 200)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

@available(iOS 16.0, *)
private struct SwiftUIBarChart: View {
    let data: [MonthlyBarData]

    var body: some View {
        Chart {
            ForEach(data) { item in
                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.income)
                )
                .foregroundStyle(.green.opacity(0.7))
                .position(by: .value("Type", "Income"))

                BarMark(
                    x: .value("Month", item.month),
                    y: .value("Amount", item.expense)
                )
                .foregroundStyle(.red.opacity(0.7))
                .position(by: .value("Type", "Expense"))
            }
        }
        .chartLegend(position: .bottom)
    }
}

private struct FallbackBarChart: View {
    let data: [MonthlyBarData]

    private var maxValue: Double {
        data.flatMap { [$0.income, $0.expense] }.max() ?? 1
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(data) { item in
                VStack(spacing: 4) {
                    HStack(alignment: .bottom, spacing: 2) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.green.opacity(0.7))
                            .frame(width: 12, height: max(2, CGFloat(item.income / maxValue) * 140))

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.red.opacity(0.7))
                            .frame(width: 12, height: max(2, CGFloat(item.expense / maxValue) * 140))
                    }
                    Text(item.month)
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
