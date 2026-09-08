import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: AyronSpacing.lg) {
                Spacer()
                Image(systemName: "message")
                    .font(.system(size: 40))
                    .foregroundStyle(AyronColor.textSubtle)
                Text("Ask your data anything.")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AyronColor.text)
                Text("Connect your sources and let Ayron query, chart, and automate.")
                    .font(.body)
                    .foregroundStyle(AyronColor.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AyronSpacing.xl)
                Button("New chat") {}
                    .buttonStyle(AyronPrimaryButtonStyle())
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AyronColor.background)
            .navigationTitle(AppTab.chat.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ChatView()
}
