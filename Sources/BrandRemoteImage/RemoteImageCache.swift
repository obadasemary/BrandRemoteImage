//
//  RemoteImageCache.swift
//  BrandRemoteImage
//
//  Created by Abdelrahman Mohamed on 06/09/2023.
//

import Foundation
import Kingfisher

/// An object that provides an access to remote images cache lifecycle
public struct RemoteImageCache {
    private let kingfisher: KingfisherManager = .shared
    
    public init() {}
    
    /// Clear remote image caches. During clear operation data will be removed from memory and disk caches
    public func clear() {
        kingfisher.cache.clearMemoryCache()
        kingfisher.cache.clearDiskCache()
    }
}
