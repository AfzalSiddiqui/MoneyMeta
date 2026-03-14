import SwiftUI

struct PieChartView: View {
    let slices: [CategorySlice]

    var body: some View {
        VStack(spacing: 12) {
            Text("Spending by Category")
                .font(.headline)

            if slices.isEmpty {
                EmptyStateView(
                    icon: "chart.pie",
                    title: "No Data",
                    message: "Add expenses to see your spending breakdown."
                )
            } else {
                GeometryReader { geometry in
                    let size = min(geometry.size.width, geometry.size.height)
                    let center = CGPoint(x: geometry.size.width / 2, y: size / 2)
                    let radius = size / 2.5

                    ZStack {
                        ForEach(Array(sliceAngles.enumerated()), id: \.offset) { index, angles in
                            PieSlice(
                                center: center,
                                radius: radius,
                                startAngle: angles.start,
                                endAngle: angles.end,
                                color: Color(hex: slices[index].colorHex)
                            )
                        }
                    }
                }
                .frame(height: 200)

                VStack(spacing: 6) {
                    ForEach(slices) { slice in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color(hex: slice.colorHex))
                                .frame(width: 10, height: 10)
                            Text(slice.categoryName)
                                .font(.caption)
                            Spacer()
                            Text(CurrencyFormatter.format(slice.amount))
                                .font(.caption.weight(.medium))
                            Text(String(format: "%.0f%%", slice.percentage))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(width: 36, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var sliceAngles: [(start: Angle, end: Angle)] {
        var angles: [(start: Angle, end: Angle)] = []
        var currentAngle: Double = -90
        let total = slices.reduce(0) { $0 + $1.amount }
        guard total > 0 else { return [] }

        for slice in slices {
            let sliceAngle = (slice.amount / total) * 360
            angles.append((
                start: Angle(degrees: currentAngle),
                end: Angle(degrees: currentAngle + sliceAngle)
            ))
            currentAngle += sliceAngle
        }
        return angles
    }
}

private struct PieSlice: View {
    let center: CGPoint
    let radius: CGFloat
    let startAngle: Angle
    let endAngle: Angle
    let color: Color

    var body: some View {
        Path { path in
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(color)
    }
}
