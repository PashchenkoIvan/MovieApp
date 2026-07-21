//
//  MovieAppDesignSystem.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import UIKit

// MARK: - Movie App Design System

enum MovieAppDesignSystem {
    enum Color {
        static let canvas = UIColor.systemBackground
        static let elevatedSurface = UIColor.secondarySystemGroupedBackground
        static let separator = UIColor.separator.withAlphaComponent(0.22)
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        static let textTertiary = UIColor.tertiaryLabel
    }

    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 24
        static let xxLarge: CGFloat = 32
    }

    enum Radius {
        static let medium: CGFloat = 14
        static let large: CGFloat = 24
    }

    enum Size {
        static let minimumTouchTarget: CGFloat = 44
        static let heroIconContainer: CGFloat = 96
        static let heroIcon: CGFloat = 42
    }
}
