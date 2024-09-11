//
//  RemoteImageView.swift
//  BrandRemoteImage
//
//  Created by Abdelrahman Mohamed on 06/09/2023.
//

import SwiftUI
import Kingfisher

/// An object that displays remote image on screen and support placeholder while image in loading or error cases
public struct RemoteImageView: View {
    public typealias ImageDownloadResultHandler = (Image) -> Void
    
    private let resource: RemoteImageResource
    private let cornerRadius: CGFloat
    private let downloadedImageHandler: ImageDownloadResultHandler?
    
    @State private var shouldUseOptimizedURL = true
    private var resourceURL: URL? {
        shouldUseOptimizedURL ? resource.url : resource.originalURL
    }
    
    /// Instanciate remote image resource
    /// - Parameters:
    ///   - resource: instance of `RemoteImageResource`
    ///   - cornerRadius: value for corner radius. By default: .zero
    ///   - downloadedImageHandler: closure that will be triggered when remote image was downloaded
    public init(
        resource: RemoteImageResource,
        cornerRadius: CGFloat = .zero,
        downloadedImageHandler: ImageDownloadResultHandler? = nil
    ) {
        self.resource = resource
        self.cornerRadius = cornerRadius
        self.downloadedImageHandler = downloadedImageHandler
    }
    
    public var body: some View {
        KFImage(resourceURL)
            .placeholder { resource.placeholder?.resizable() }
            .onSuccess({ result in
                guard 
                    let handler = self.downloadedImageHandler,
                    result.source.url?.absoluteString == resourceURL?.absoluteString
                else {
                    return
                }
                handler(.init(uiImage: result.image))
            })
            .onFailure({ error in
                /// Need this handler for situation when our image optimization engine on backend can't create optimized image
                /// or optimized image damaged. In that case we need to redownload image with original URL
                switch error {
                case .responseError(let reason):
                    switch reason {
                    case .invalidHTTPStatusCode(let response):
                        if response.url?.absoluteString == resource.url?.absoluteString {
                            self.shouldUseOptimizedURL = false
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            })
            .resizable()
            .scaledToFit()
            .cornerRadius(cornerRadius)
    }
}
