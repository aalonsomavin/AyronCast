import SwiftUI

enum AyronColor {
    static let background = Color(red: 1, green: 1, blue: 1)
    static let backgroundSubtle = Color(red: 0.973, green: 0.973, blue: 0.976)
    static let backgroundMuted = Color(red: 0.949, green: 0.949, blue: 0.957)
    static let ink = Color(red: 0.09, green: 0.09, blue: 0.11)
    static let primary = Color(red: 0.09, green: 0.09, blue: 0.11)
    static let primaryForeground = Color.white
    static let accent = Color(red: 0.231, green: 0.431, blue: 0.965)
    static let border = Color(red: 0.902, green: 0.902, blue: 0.906)
    static let text = Color(red: 0.09, green: 0.09, blue: 0.11)
    static let textMuted = Color(red: 0.388, green: 0.388, blue: 0.416)
    static let textSubtle = Color(red: 0.541, green: 0.541, blue: 0.569)
    static let surfaceHover = Color(red: 0.961, green: 0.961, blue: 0.965)
    static let selectionBackground = Color(red: 0.941, green: 0.953, blue: 1)
}

enum AyronSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}

enum AyronRadius {
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
}

struct AyronPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(AyronColor.primaryForeground)
            .padding(.horizontal, AyronSpacing.lg)
            .padding(.vertical, AyronSpacing.sm)
            .background(AyronColor.primary.opacity(configuration.isPressed ? 0.85 : 1))
            .clipShape(RoundedRectangle(cornerRadius: AyronRadius.md))
    }
}

struct AyronSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(AyronColor.text)
            .padding(.horizontal, AyronSpacing.lg)
            .padding(.vertical, AyronSpacing.sm)
            .background(AyronColor.background)
            .overlay(
                RoundedRectangle(cornerRadius: AyronRadius.md)
                    .stroke(AyronColor.border, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}
