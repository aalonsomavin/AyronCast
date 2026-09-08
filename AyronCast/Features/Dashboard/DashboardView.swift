import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AyronSpacing.lg) {
                    metricCard(title: "Revenue", value: "$284,320", delta: "+12.4% vs last month")
                    metricCard(title: "Active users", value: "1,842", delta: "+3.1% vs last week")
                    Text("Charts and tables will connect to the Ayron backend in Fase 4.")
                        .font(.footnote)
                        .foregroundStyle(AyronColor.textMuted)
                }
                .padding(AyronSpacing.lg)
            }
            .background(AyronColor.backgroundSubtle)
            .navigationTitle(AppTab.dashboard.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func metricCard(title: String, value: String, delta: String) -> some View {
        VStack(alignment: .leading, spacing: AyronSpacing.sm) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(AyronColor.textMuted)
            Text(value)
                .font(.system(size: 28, weight: .semibold, design: .monospaced))
                .foregroundStyle(AyronColor.text)
            Text(delta)
                .font(.caption)
                .foregroundStyle(AyronColor.textSubtle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AyronSpacing.lg)
        .background(AyronColor.background)
        .clipShape(RoundedRectangle(cornerRadius: AyronRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AyronRadius.lg)
                .stroke(AyronColor.border, lineWidth: 1)
        )
    }
}

#Preview {
    DashboardView()
}
