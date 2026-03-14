import SwiftUI

struct CategoryIconView: View {
    let colorHex: String
    let icon: String
    var size: CGFloat = 36

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: colorHex).opacity(0.2))
                .frame(width: size, height: size)
            Image(systemName: icon)
                .font(.system(size: size * 0.4))
                .foregroundColor(Color(hex: colorHex))
        }
    }
}
