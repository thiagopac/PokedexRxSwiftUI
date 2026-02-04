import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.appSecondaryText)

            TextField("Search Pokemon", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.appSecondaryText)
                }
                .accessibilityIdentifier("clear_search")
            }
        }
        .padding(10)
        .background(Color.appSecondaryBackground)
        .cornerRadius(12)
    }
}
