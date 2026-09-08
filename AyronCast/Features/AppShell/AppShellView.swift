import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case chat
    case dashboard
    case sources
    case automations

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chat: "Chat"
        case .dashboard: "Dashboard"
        case .sources: "Sources"
        case .automations: "Automations"
        }
    }

    var subtitle: String {
        switch self {
        case .chat: "Ask Ayron anything about your data"
        case .dashboard: "Revenue overview"
        case .sources: "Manage your connected data sources"
        case .automations: "Scheduled workflows and alerts"
        }
    }

    var systemImage: String {
        switch self {
        case .chat: "message"
        case .dashboard: "chart.line.uptrend.xyaxis"
        case .sources: "cylinder"
        case .automations: "bolt"
        }
    }
}

struct AppShellView: View {
    @State private var selectedTab: AppTab = .chat

    var body: some View {
        TabView(selection: $selectedTab) {
            ChatView()
                .tabItem { Label(AppTab.chat.title, systemImage: AppTab.chat.systemImage) }
                .tag(AppTab.chat)

            DashboardView()
                .tabItem { Label(AppTab.dashboard.title, systemImage: AppTab.dashboard.systemImage) }
                .tag(AppTab.dashboard)

            SourcesView()
                .tabItem { Label(AppTab.sources.title, systemImage: AppTab.sources.systemImage) }
                .tag(AppTab.sources)

            AutomationsView()
                .tabItem { Label(AppTab.automations.title, systemImage: AppTab.automations.systemImage) }
                .tag(AppTab.automations)
        }
        .tint(AyronColor.accent)
    }
}

#Preview {
    AppShellView()
}
