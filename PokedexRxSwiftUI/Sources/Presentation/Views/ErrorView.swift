import SwiftUI

struct ErrorView: View {
    let message: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.headline)
                .foregroundColor(Color.appPrimaryText)
                .multilineTextAlignment(.center)

            Button(action: action) {
                Text("Try Again")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.appPrimaryText)
                    .foregroundColor(Color.appBackground)
                    .cornerRadius(10)
            }
        }
    }
}
