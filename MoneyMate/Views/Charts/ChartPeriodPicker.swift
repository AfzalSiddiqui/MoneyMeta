import SwiftUI

struct ChartPeriodPicker: View {
    @Binding var selection: ChartPeriod

    var body: some View {
        Picker("Period", selection: $selection) {
            ForEach(ChartPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
}
