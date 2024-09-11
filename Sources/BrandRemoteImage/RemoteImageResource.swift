//
//  RemoteImageConfiguration.swift
//  BrandRemoteImage
//
//  Created by Abdelrahman Mohamed on 06/09/2023.
//

import SwiftUI

/// An object that represents image that should be loaded from given URL.
/// Original image path always pass additional optimizations to provide best quality image and reduce amount of disk writing operations
public struct RemoteImageResource: Hashable {
    public let url: URL?
    public let originalURL: URL?
    public let placeholder: Image?
    
    /// Initialize resouce object
    /// - Parameters:
    ///   - path: original path from API response. Internally this pasth will be modified. For more details, please check `makeUrlWithDeviceScale` method
    ///   - placeholder: placeholder image that will be displayed while target image is loading or in error cases
    ///   - deviceScale: remote image scale option based on `UIScreen.main.scale`
    public init(
        path: String,
        placeholder: Image?,
        deviceScale: RemoteImageResource.Scale = Self.getDeviceScale()
    ) {
        self.url = Self.makeUrlWithDeviceScale(
            path,
            scale: deviceScale
        )
        self.originalURL = .init(string: path)
        self.placeholder = placeholder
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.url)
    }
}

public extension RemoteImageResource {
    enum Scale: CGFloat {
        case xHDPI = 2.0
        case xxHDPI = 3.0
        
        var stringValue: String {
            String(describing: self).uppercased()
        }
    }
    
    static func getDeviceScale() -> Scale {
        Scale(rawValue: UIScreen.main.scale) ?? .xxHDPI
    }
    
    /// Creates new URL with scale prefix based on current device screen scale.
    /// The main reason for that functionality — display on screen hight quality images for current device and reduce amount of disk operations
    private static func makeUrlWithDeviceScale(
        _ input: String,
        scale: Scale
    ) -> URL? {
        /// Algorithm logic
        ///
        /// Case `A`: input url contains image name **with extension** in the end, like `.png/.jpg`
        /// In that case the environment isnt production, return the input url as it without any modifications
        /// As result, final url path should be: `https://path_to_image/imageName.png`
        ///
        /// Case `B`: input url contains image name **with extension** in the end, like `.png/.jpg`
        /// In that case needs to add scale prefix (for example: `_XXHDPI`) before file extension.
        /// As result, final url path should be: `https://path_to_image/imageName_XXHDPI.png`
        ///
        /// Case `C`: input url contains image name **without extension** in the end.
        /// In that case needs to add scale prefix in the end of original input
        /// As result, final url path should be: `https://path_to_image/imageName_XXHDPI`
        
        let urlComponents = input.components(separatedBy: "/").filter({ !$0.isEmpty })
        let originalImageName = urlComponents.last ?? ""
        
        var imageNameWithScale = ""
        if originalImageName.contains(".") {
            let splittedNameByComponents = (urlComponents.last ?? "").components(separatedBy: ".")
            imageNameWithScale = "\(splittedNameByComponents.first ?? "")_\(scale.stringValue).\(splittedNameByComponents.last ?? "")"
        } else {
            imageNameWithScale = "\(originalImageName)_\(scale.stringValue)"
        }
        
        let resultPath = input.replacingOccurrences(of: originalImageName, with: imageNameWithScale)
        return .init(string: resultPath)
    }
}
