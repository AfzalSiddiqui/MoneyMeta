import SwiftUI

struct ColorPickerGridView: View {
    @Binding var selectedHex: String

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(CategoryColors.all, id: \.hex) { color in
                Circle()
                    .fill(Color(hex: color.hex))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: selectedHex == color.hex ? 3 : 0)
                            .padding(-3)
                    )
                    .onTapGesture {
                        selectedHex = color.hex
                    }
            }
        }
        .padding(.vertical, 8)
    }
}
