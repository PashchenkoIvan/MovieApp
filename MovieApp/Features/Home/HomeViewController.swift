//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 21/07/2026.
//

import SnapKit
import UIKit

private enum HomeSection: Int, CaseIterable {
    case hero
    case trailers
    case popular
    case topRated
    case upcoming
}

final class HomeViewController: BaseViewController<HomeViewModel> {
    private var collectionView: UICollectionView!
    private let messageView = HomeMessageView()
    private var featuredMovie: Movie?
    private var trailers: [MovieTrailer] = []
    private var movieSections: [(section: HomeSection, movies: [Movie])] = []

    init(
        viewModel: HomeViewModel,
        localizationService: LocalizationServiceProtocol = LocalizationService.shared
    ) {
        super.init(viewModel: viewModel, screen: .home, localizationService: localizationService)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func setupUI() {
        title = localized("home.title", value: "Home")
        view.backgroundColor = MovieAppDesignSystem.Color.canvas
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupCollectionView()
        setupMessageView()
    }

    override func render(_ state: HomeViewState) {
        switch state {
        case .idle, .loading:
            collectionView.isHidden = true
            messageView.isHidden = true
        case .content(let homeMovies):
            collectionView.isHidden = false
            messageView.isHidden = true
            render(homeMovies)
        case .empty:
            collectionView.isHidden = true
            showMessage(
                iconName: "film.stack",
                title: localized("home.empty.title", value: "No movies yet"),
                message: localized("home.empty.message", value: "Movie discovery will appear here when TMDB returns results.")
            )
        case .failed(let message):
            collectionView.isHidden = true
            showMessage(
                iconName: "wifi.exclamationmark",
                title: localized("home.error.title", value: "Could not load movies"),
                message: message.isEmpty ? localized("home.error.message", value: "Check your connection and try again.") : message
            )
        }
    }
}

private extension HomeViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeHeroCell.self, forCellWithReuseIdentifier: HomeHeroCell.reuseIdentifier)
        collectionView.register(HomeTrailerCell.self, forCellWithReuseIdentifier: HomeTrailerCell.reuseIdentifier)
        collectionView.register(HomeMovieCell.self, forCellWithReuseIdentifier: HomeMovieCell.reuseIdentifier)
        collectionView.register(
            HomeSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier
        )

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupMessageView() {
        messageView.isHidden = true
        messageView.onAction = { [weak self] in
            self?.viewModel.retry()
        }

        view.addSubview(messageView)
        messageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(MovieAppDesignSystem.Spacing.xLarge)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = self?.sectionKind(at: sectionIndex) else { return nil }

            switch section {
            case .hero:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(430))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 26, trailing: 16)
                return layoutSection
            case .trailers:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(286), heightDimension: .absolute(162))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                layoutSection.interGroupSpacing = 14
                layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
                layoutSection.boundarySupplementaryItems = [self?.makeHeaderItem()].compactMap { $0 }
                return layoutSection
            case .popular, .topRated, .upcoming:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(156), heightDimension: .estimated(300))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(156), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                layoutSection.interGroupSpacing = 14
                layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 28, trailing: 16)
                layoutSection.boundarySupplementaryItems = [self?.makeHeaderItem()].compactMap { $0 }
                return layoutSection
            }
        }
    }

    func makeHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    func render(_ homeMovies: HomeMovies) {
        featuredMovie = homeMovies.featured
        trailers = homeMovies.trailers
        movieSections = [
            (.popular, homeMovies.popular),
            (.topRated, homeMovies.topRated),
            (.upcoming, homeMovies.upcoming)
        ].filter { !$0.movies.isEmpty }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        animateVisibleContentIfNeeded()
    }

    func showMessage(iconName: String, title: String, message: String) {
        messageView.configure(
            iconName: iconName,
            title: title,
            message: message,
            actionTitle: localized("home.retry", value: "Retry")
        )
        messageView.isHidden = false
        animateMessageIfNeeded()
    }

    func animateVisibleContentIfNeeded() {
        guard !UIAccessibility.isReduceMotionEnabled else {
            collectionView.visibleCells.forEach {
                $0.alpha = 1
                $0.transform = .identity
            }
            return
        }

        let visibleCells = collectionView.visibleCells.sorted {
            guard let lhs = collectionView.indexPath(for: $0), let rhs = collectionView.indexPath(for: $1) else {
                return false
            }

            if lhs.section == rhs.section {
                return lhs.item < rhs.item
            }
            return lhs.section < rhs.section
        }

        for (index, cell) in visibleCells.enumerated() {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 18).scaledBy(x: 0.98, y: 0.98)
            UIView.animate(
                withDuration: 0.52,
                delay: min(Double(index) * 0.045, 0.28),
                usingSpringWithDamping: 0.86,
                initialSpringVelocity: 0.45,
                options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]
            ) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }

    func animateMessageIfNeeded() {
        guard !UIAccessibility.isReduceMotionEnabled else {
            messageView.alpha = 1
            messageView.transform = .identity
            return
        }

        messageView.alpha = 0
        messageView.transform = CGAffineTransform(translationX: 0, y: 14)
        UIView.animate(
            withDuration: 0.34,
            delay: 0,
            options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut]
        ) {
            self.messageView.alpha = 1
            self.messageView.transform = .identity
        }
    }

    func setCell(_ cell: UICollectionViewCell, highlighted: Bool) {
        guard !UIAccessibility.isReduceMotionEnabled else { return }

        let targetTransform = highlighted ? CGAffineTransform(scaleX: 0.965, y: 0.965) : .identity
        UIView.animate(
            withDuration: highlighted ? 0.16 : 0.34,
            delay: 0,
            usingSpringWithDamping: highlighted ? 1 : 0.72,
            initialSpringVelocity: 0.35,
            options: [.allowUserInteraction, .beginFromCurrentState]
        ) {
            cell.transform = targetTransform
        }
    }

    func sectionKind(at sectionIndex: Int) -> HomeSection? {
        if featuredMovie != nil && sectionIndex == 0 {
            return .hero
        }

        let trailerOffset = featuredMovie == nil ? 0 : 1
        if !trailers.isEmpty && sectionIndex == trailerOffset {
            return .trailers
        }

        let movieSectionIndex = sectionIndex - trailerOffset - (trailers.isEmpty ? 0 : 1)
        guard movieSections.indices.contains(movieSectionIndex) else { return nil }
        return movieSections[movieSectionIndex].section
    }

    func movies(at sectionIndex: Int) -> [Movie] {
        let movieSectionIndex = sectionIndex - (featuredMovie == nil ? 0 : 1) - (trailers.isEmpty ? 0 : 1)
        guard movieSections.indices.contains(movieSectionIndex) else { return [] }
        return movieSections[movieSectionIndex].movies
    }

    func trailer(at indexPath: IndexPath) -> MovieTrailer? {
        guard sectionKind(at: indexPath.section) == .trailers,
              trailers.indices.contains(indexPath.item) else { return nil }
        return trailers[indexPath.item]
    }

    func title(for section: HomeSection) -> String {
        switch section {
        case .hero:
            return ""
        case .trailers:
            return localized("home.section.trailers", value: "Trailers")
        case .popular:
            return localized("home.section.popular", value: "Popular now")
        case .topRated:
            return localized("home.section.topRated", value: "Critically loved")
        case .upcoming:
            return localized("home.section.upcoming", value: "Coming soon")
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        movieSections.count + (featuredMovie == nil ? 0 : 1) + (trailers.isEmpty ? 0 : 1)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionKind(at: section) {
        case .hero:
            return 1
        case .trailers:
            return trailers.count
        case .popular, .topRated, .upcoming:
            return movies(at: section).count
        case nil:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionKind(at: indexPath.section) {
        case .hero:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeroCell.reuseIdentifier, for: indexPath) as? HomeHeroCell
            if let featuredMovie {
                cell?.configure(with: featuredMovie)
            }
            return cell ?? UICollectionViewCell()
        case .trailers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTrailerCell.reuseIdentifier, for: indexPath) as? HomeTrailerCell
            if let trailer = trailer(at: indexPath) {
                cell?.configure(with: trailer)
            }
            return cell ?? UICollectionViewCell()
        case .popular, .topRated, .upcoming:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMovieCell.reuseIdentifier, for: indexPath) as? HomeMovieCell
            let sectionMovies = movies(at: indexPath.section)
            if sectionMovies.indices.contains(indexPath.item) {
                cell?.configure(with: sectionMovies[indexPath.item])
            }
            return cell ?? UICollectionViewCell()
        case nil:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let section = sectionKind(at: indexPath.section),
              section != .hero,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier,
                for: indexPath
              ) as? HomeSectionHeaderView else {
            return UICollectionReusableView()
        }

        header.configure(title: title(for: section))
        return header
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        setCell(cell, highlighted: true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        setCell(cell, highlighted: false)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = trailer(at: indexPath)?.externalURL else { return }
        UIApplication.shared.open(url)
    }
}

private final class HomeHeroCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeHeroCell"

    private let imageView = RemoteMovieImageView(imageSize: .backdrop)
    private let gradientView = GradientOverlayView()
    private let eyebrowLabel = UILabel()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let metadataLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
        transform = .identity
        imageView.cancelLoad()
    }

    func configure(with movie: Movie) {
        imageView.setPath(movie.backdropPath ?? movie.posterPath)
        eyebrowLabel.text = "Featured tonight"
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview.isEmpty ? "A standout pick from today's movie conversation." : movie.overview
        metadataLabel.text = metadata(for: movie)
        accessibilityLabel = [movie.title, metadataLabel.text, overviewLabel.text].compactMap { $0 }.joined(separator: ". ")
    }

    private func setupUI() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        contentView.layer.cornerRadius = 24
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = MovieAppDesignSystem.Color.elevatedSurface

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        eyebrowLabel.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .systemFont(ofSize: 12, weight: .semibold))
        eyebrowLabel.textColor = .white.withAlphaComponent(0.82)
        eyebrowLabel.adjustsFontForContentSizeCategory = true

        titleLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: .systemFont(ofSize: 34, weight: .bold))
        titleLabel.textColor = .white
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 3

        overviewLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        overviewLabel.textColor = .white.withAlphaComponent(0.86)
        overviewLabel.adjustsFontForContentSizeCategory = true
        overviewLabel.numberOfLines = 4

        metadataLabel.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .monospacedDigitSystemFont(ofSize: 13, weight: .semibold))
        metadataLabel.textColor = .white
        metadataLabel.adjustsFontForContentSizeCategory = true
        metadataLabel.numberOfLines = 2

        let contentStack = UIStackView(arrangedSubviews: [eyebrowLabel, titleLabel, overviewLabel, metadataLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.alignment = .leading

        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(contentStack)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(390)
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(24)
            make.top.greaterThanOrEqualToSuperview().inset(140)
        }
    }

    private func metadata(for movie: Movie) -> String {
        let rating = movie.voteAverage > 0 ? String(format: "%.1f", movie.voteAverage) : "New"
        return [movie.releaseYear, "★ \(rating)"].compactMap { $0 }.joined(separator: "  ")
    }
}

private final class HomeTrailerCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeTrailerCell"

    private let thumbnailView = RemoteMovieImageView(imageSize: .backdrop)
    private let gradientView = GradientOverlayView()
    private let playContainerView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
        transform = .identity
        thumbnailView.cancelLoad()
    }

    func configure(with trailer: MovieTrailer) {
        thumbnailView.setURL(trailer.thumbnailURL)
        titleLabel.text = trailer.movieTitle
        subtitleLabel.text = trailer.name
        accessibilityLabel = "\(trailer.movieTitle), \(trailer.name)"
        accessibilityHint = "Opens trailer"
    }

    private func setupUI() {
        isAccessibilityElement = true
        accessibilityTraits = .button
        contentView.layer.cornerRadius = 18
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = MovieAppDesignSystem.Color.elevatedSurface

        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true

        playContainerView.layer.cornerRadius = 24
        playContainerView.layer.cornerCurve = .continuous
        playContainerView.layer.masksToBounds = true
        playImageView.tintColor = .white
        playImageView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 2

        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subtitleLabel.textColor = .white.withAlphaComponent(0.82)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.numberOfLines = 1

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4

        contentView.addSubview(thumbnailView)
        contentView.addSubview(gradientView)
        contentView.addSubview(playContainerView)
        playContainerView.contentView.addSubview(playImageView)
        contentView.addSubview(labelStack)

        thumbnailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        playContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(48)
        }
        playImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18)
        }
        labelStack.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}

private final class HomeMovieCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeMovieCell"

    private let posterView = RemoteMovieImageView(imageSize: .poster)
    private let ratingLabel = UILabel()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
        transform = .identity
        posterView.cancelLoad()
    }

    func configure(with movie: Movie) {
        posterView.setPath(movie.posterPath)
        ratingLabel.text = movie.voteAverage > 0 ? String(format: "★ %.1f", movie.voteAverage) : movie.releaseYear ?? "New"
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseYear ?? ""
        accessibilityLabel = [movie.title, yearLabel.text, ratingLabel.text].compactMap { $0 }.joined(separator: ", ")
    }

    private func setupUI() {
        isAccessibilityElement = true
        accessibilityTraits = .button

        posterView.contentMode = .scaleAspectFill
        posterView.clipsToBounds = true
        posterView.layer.cornerRadius = 16
        posterView.layer.cornerCurve = .continuous
        posterView.backgroundColor = MovieAppDesignSystem.Color.elevatedSurface

        ratingLabel.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .monospacedDigitSystemFont(ofSize: 12, weight: .bold))
        ratingLabel.textColor = MovieAppDesignSystem.Color.textPrimary
        ratingLabel.adjustsFontForContentSizeCategory = true

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = MovieAppDesignSystem.Color.textPrimary
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 2

        yearLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        yearLabel.textColor = MovieAppDesignSystem.Color.textSecondary
        yearLabel.adjustsFontForContentSizeCategory = true

        let stack = UIStackView(arrangedSubviews: [posterView, ratingLabel, titleLabel, yearLabel])
        stack.axis = .vertical
        stack.spacing = 7
        stack.setCustomSpacing(10, after: posterView)

        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        posterView.snp.makeConstraints { make in
            make.height.equalTo(posterView.snp.width).multipliedBy(1.5)
        }
    }
}

private final class HomeSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HomeSectionHeaderView"

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).withWeight(.bold)
        titleLabel.textColor = MovieAppDesignSystem.Color.textPrimary
        titleLabel.adjustsFontForContentSizeCategory = true
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

private final class HomeMessageView: UIView {
    var onAction: (() -> Void)?

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func configure(iconName: String, title: String, message: String, actionTitle: String) {
        iconView.image = UIImage(systemName: iconName)
        titleLabel.text = title
        messageLabel.text = message
        actionButton.setTitle(actionTitle, for: .normal)
        accessibilityLabel = [title, message].joined(separator: ". ")
    }

    private func setupUI() {
        isAccessibilityElement = false
        iconView.tintColor = MovieAppDesignSystem.Color.textPrimary
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).withWeight(.bold)
        titleLabel.textColor = MovieAppDesignSystem.Color.textPrimary
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.textColor = MovieAppDesignSystem.Color.textSecondary
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "arrow.clockwise")
        configuration.imagePadding = 8
        actionButton.configuration = configuration
        actionButton.addAction(UIAction { [weak self] _ in self?.onAction?() }, for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, messageLabel, actionButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 14
        stack.setCustomSpacing(20, after: messageLabel)

        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        iconView.snp.makeConstraints { make in
            make.size.equalTo(54)
        }
    }
}

private final class RemoteMovieImageView: UIImageView {
    enum ImageSize {
        case poster
        case backdrop

        var baseURL: String {
            switch self {
            case .poster:
                return "https://image.tmdb.org/t/p/w500"
            case .backdrop:
                return "https://image.tmdb.org/t/p/w780"
            }
        }
    }

    private let imageSize: ImageSize
    private var loadTask: Task<Void, Never>?

    init(imageSize: ImageSize) {
        self.imageSize = imageSize
        super.init(frame: .zero)
        image = UIImage(systemName: "film")
        tintColor = MovieAppDesignSystem.Color.textTertiary
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    func setPath(_ path: String?) {
        guard let path else {
            setURL(nil)
            return
        }

        setURL(URL(string: imageSize.baseURL + path))
    }

    func setURL(_ url: URL?) {
        cancelLoad()
        image = UIImage(systemName: "film")
        tintColor = MovieAppDesignSystem.Color.textTertiary

        guard let url else { return }

        loadTask = Task { [weak self] in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled, let image = UIImage(data: data) else { return }

                await MainActor.run {
                    guard let self else { return }
                    guard !UIAccessibility.isReduceMotionEnabled else {
                        self.image = image
                        self.tintColor = nil
                        return
                    }

                    UIView.transition(with: self, duration: 0.24, options: [.transitionCrossDissolve, .allowUserInteraction]) {
                        self.image = image
                        self.tintColor = nil
                    }
                }
            } catch {
                return
            }
        }
    }

    func cancelLoad() {
        loadTask?.cancel()
        loadTask = nil
    }
}

private final class GradientOverlayView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = [
            UIColor.black.withAlphaComponent(0.05).cgColor,
            UIColor.black.withAlphaComponent(0.38).cgColor,
            UIColor.black.withAlphaComponent(0.82).cgColor
        ]
        gradientLayer?.locations = [0, 0.48, 1]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}

private extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
