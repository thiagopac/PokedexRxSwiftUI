import SwiftUI

struct LoadingView: View {
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text(title)
                .font(.headline)
                .foregroundColor(Color.appPrimaryText)
        }
    }
}
