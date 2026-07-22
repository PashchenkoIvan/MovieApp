//
//  MovieImageLoader.swift
//  MovieApp
//
//  Created by Ivan P. on 22/07/2026.
//

import ImageIO
import UIKit

actor MovieImageLoader {
    static let shared = MovieImageLoader()

    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()

    init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 160
        cache.totalCostLimit = 48 * 1024 * 1024
    }

    func image(from url: URL, targetSize: CGSize, scale: CGFloat) async throws -> UIImage {
        let cacheKey = url as NSURL
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        let image = try downsampledImage(from: data, targetSize: targetSize, scale: scale)
        cache.setObject(image, forKey: cacheKey, cost: data.count)
        return image
    }

    private func downsampledImage(from data: Data, targetSize: CGSize, scale: CGFloat) throws -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            throw APIError.invalidResponse
        }

        let maxDimension = max(targetSize.width, targetSize.height) * max(scale, 1)
        let thumbnailOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: max(Int(maxDimension), 1)
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions) else {
            throw APIError.invalidResponse
        }

        return UIImage(cgImage: cgImage)
    }
}
