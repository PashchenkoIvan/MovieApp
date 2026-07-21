//
//  TabPlaceholderViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import SnapKit
import UIKit

// MARK: - Tab Placeholder Configuration

struct TabPlaceholderHighlight {
    let iconName: String
    let title: String
    let subtitle: String
}

struct TabPlaceholderConfiguration {
    let iconName: String
    let title: String
    let subtitle: String
    let accentColor: UIColor
    let highlights: [TabPlaceholderHighlight]
}

// MARK: - Tab Placeholder View Controller

class TabPlaceholderViewController: UIViewController {
    private let configuration: TabPlaceholderConfiguration

    // MARK: - Init

    init(configuration: TabPlaceholderConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Setup

private extension TabPlaceholderViewController {
    func setupUI() {
        view.backgroundColor = MovieAppDesignSystem.Color.canvas

        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .automatic

        let contentView = UIView()
        let stackView = UIStackView(arrangedSubviews: [
            makeHeroView(),
            makeHighlightListView()
        ])
        stackView.axis = .vertical
        stackView.spacing = MovieAppDesignSystem.Spacing.xxLarge

        contentView.addSubview(stackView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(MovieAppDesignSystem.Spacing.xLarge)
            make.top.equalToSuperview().inset(MovieAppDesignSystem.Spacing.xxLarge)
            make.bottom.equalToSuperview().inset(MovieAppDesignSystem.Spacing.xxLarge)
        }
    }

    func makeHeroView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = MovieAppDesignSystem.Color.elevatedSurface
        containerView.layer.cornerRadius = MovieAppDesignSystem.Radius.large
        containerView.layer.cornerCurve = .continuous
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = MovieAppDesignSystem.Color.separator.cgColor
        containerView.accessibilityIdentifier = "tabPlaceholder.hero"

        let iconBackgroundView = UIView()
        iconBackgroundView.backgroundColor = configuration.accentColor.withAlphaComponent(0.14)
        iconBackgroundView.layer.cornerRadius = MovieAppDesignSystem.Radius.large
        iconBackgroundView.layer.cornerCurve = .continuous
        iconBackgroundView.isAccessibilityElement = false

        let iconImageView = UIImageView(image: UIImage(systemName: configuration.iconName))
        iconImageView.tintColor = configuration.accentColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 38, weight: .semibold)
        iconImageView.isAccessibilityElement = false

        let titleLabel = UILabel()
        titleLabel.text = configuration.title
        titleLabel.textColor = MovieAppDesignSystem.Color.textPrimary
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let subtitleLabel = UILabel()
        subtitleLabel.text = configuration.subtitle
        subtitleLabel.textColor = MovieAppDesignSystem.Color.textSecondary
        subtitleLabel.font = .preferredFont(forTextStyle: .body)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        iconBackgroundView.addSubview(iconImageView)

        let stackView = UIStackView(arrangedSubviews: [
            iconBackgroundView,
            titleLabel,
            subtitleLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = MovieAppDesignSystem.Spacing.medium
        stackView.setCustomSpacing(MovieAppDesignSystem.Spacing.xLarge, after: iconBackgroundView)

        containerView.addSubview(stackView)

        iconBackgroundView.snp.makeConstraints { make in
            make.size.equalTo(MovieAppDesignSystem.Size.heroIconContainer)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(MovieAppDesignSystem.Size.heroIcon)
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(MovieAppDesignSystem.Spacing.xLarge)
        }

        containerView.isAccessibilityElement = true
        containerView.accessibilityLabel = [configuration.title, configuration.subtitle].joined(separator: ". ")
        containerView.accessibilityTraits = .staticText

        return containerView
    }

    func makeHighlightListView() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = MovieAppDesignSystem.Spacing.medium

        configuration.highlights.forEach { highlight in
            stackView.addArrangedSubview(makeHighlightRow(for: highlight))
        }

        return stackView
    }

    func makeHighlightRow(for highlight: TabPlaceholderHighlight) -> UIView {
        let iconContainerView = UIView()
        iconContainerView.backgroundColor = configuration.accentColor.withAlphaComponent(0.10)
        iconContainerView.layer.cornerRadius = MovieAppDesignSystem.Radius.medium
        iconContainerView.layer.cornerCurve = .continuous
        iconContainerView.isAccessibilityElement = false

        let iconImageView = UIImageView(image: UIImage(systemName: highlight.iconName))
        iconImageView.tintColor = configuration.accentColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        iconImageView.isAccessibilityElement = false

        let titleLabel = UILabel()
        titleLabel.text = highlight.title
        titleLabel.textColor = MovieAppDesignSystem.Color.textPrimary
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0

        let subtitleLabel = UILabel()
        subtitleLabel.text = highlight.subtitle
        subtitleLabel.textColor = MovieAppDesignSystem.Color.textSecondary
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.numberOfLines = 0

        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.spacing = MovieAppDesignSystem.Spacing.xSmall

        let rowView = UIView()
        rowView.backgroundColor = MovieAppDesignSystem.Color.elevatedSurface
        rowView.layer.cornerRadius = MovieAppDesignSystem.Radius.medium
        rowView.layer.cornerCurve = .continuous
        rowView.layer.borderWidth = 1
        rowView.layer.borderColor = MovieAppDesignSystem.Color.separator.cgColor
        rowView.accessibilityIdentifier = "tabPlaceholder.highlight"

        rowView.addSubview(iconContainerView)
        rowView.addSubview(textStackView)
        iconContainerView.addSubview(iconImageView)

        iconContainerView.snp.makeConstraints { make in
            make.leading.top.greaterThanOrEqualToSuperview().inset(MovieAppDesignSystem.Spacing.large)
            make.leading.equalToSuperview().inset(MovieAppDesignSystem.Spacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(MovieAppDesignSystem.Size.minimumTouchTarget)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(22)
        }

        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView.snp.trailing).offset(MovieAppDesignSystem.Spacing.medium)
            make.top.bottom.trailing.equalToSuperview().inset(MovieAppDesignSystem.Spacing.large)
        }

        rowView.isAccessibilityElement = true
        rowView.accessibilityLabel = [highlight.title, highlight.subtitle].joined(separator: ". ")
        rowView.accessibilityTraits = .staticText

        return rowView
    }
}
