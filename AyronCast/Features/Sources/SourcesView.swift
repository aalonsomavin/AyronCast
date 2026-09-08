import SwiftUI

struct SourcesView: View {
    private let placeholders = [
        ("Postgres", "Connected"),
        ("Stripe", "Syncing"),
        ("Google Analytics", "Disconnected"),
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(placeholders, id: \.0) { name, status in
                        HStack {
                            Image(systemName: "cylinder")
                                .foregroundStyle(AyronColor.textMuted)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(name)
                                    .foregroundStyle(AyronColor.text)
                                Text(status)
                                    .font(.caption)
                                    .foregroundStyle(AyronColor.textSubtle)
                            }
                        }
                    }
                } header: {
                    Text("Connected sources")
                }
            }
            .navigationTitle(AppTab.sources.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Connect a source") {}
                        .buttonStyle(AyronPrimaryButtonStyle())
                }
            }
        }
    }
}

#Preview {
    SourcesView()
}
