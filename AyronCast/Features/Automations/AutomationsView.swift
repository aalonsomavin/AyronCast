import SwiftUI

struct AutomationsView: View {
    @State private var weeklyReportEnabled = true
    @State private var revenueAlertEnabled = false

    var body: some View {
        NavigationStack {
            List {
                automationRow(
                    title: "Weekly revenue report",
                    detail: "Every Monday · 9:00 AM",
                    isOn: $weeklyReportEnabled
                )
                automationRow(
                    title: "Revenue drop alert",
                    detail: "When revenue falls 10% week over week",
                    isOn: $revenueAlertEnabled
                )
            }
            .navigationTitle(AppTab.automations.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New automation") {}
                        .buttonStyle(AyronPrimaryButtonStyle())
                }
            }
        }
    }

    private func automationRow(title: String, detail: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundStyle(AyronColor.text)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(AyronColor.textSubtle)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(AyronColor.accent)
        }
        .padding(.vertical, AyronSpacing.xs)
    }
}

#Preview {
    AutomationsView()
}
