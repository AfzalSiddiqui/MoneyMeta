import SwiftUI

struct ChartsContainerView: View {
    @StateObject private var viewModel = ChartViewModel()
    @ObservedObject private var hintManager = HintManager.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Button {
                            viewModel.currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.currentMonth) ?? viewModel.currentMonth
                            viewModel.refresh()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        Spacer()
                        Text(DateFormatters.monthYear.string(from: viewModel.currentMonth))
                            .font(.headline)
                        Spacer()
                        Button {
                            viewModel.currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.currentMonth) ?? viewModel.currentMonth
                            viewModel.refresh()
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.horizontal)

                    HintBubble(hint: .chartNav)
                        .padding(.horizontal)

                    PieChartView(slices: viewModel.categorySlices)

                    BarChartView(data: viewModel.monthlyData, period: $viewModel.selectedPeriod)
                        .onChange(of: viewModel.selectedPeriod) { _ in
                            viewModel.refresh()
                        }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Charts")
            .onAppear {
                viewModel.refresh()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    hintManager.showIfNeeded(.chartNav)
                }
            }
        }
    }
}
