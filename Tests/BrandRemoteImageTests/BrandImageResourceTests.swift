//
//  BrandImageResourceTests.swift
//  BrandRemoteImage
//
//  Created by Abdelrahman Mohamed on 11/09/2023.
//

import XCTest
import BrandRemoteImage

final class RemoteImageResourceTests: XCTestCase {
    func testWithExtensionInImageURL() {
        let expectedResult = "https://cdn.breadfast.tech/wp-content/uploads/2022/12/Food_Cupboard_app_en_copy_2_c3eff61d88_XXHDPI.png"
        let input = "https://cdn.breadfast.tech/wp-content/uploads/2022/12/Food_Cupboard_app_en_copy_2_c3eff61d88.png"
        test(expectedResult, input)
    }
    
    func testWithoutExtensionInImageURL() {
        let expectedResult = "https:/storage.googleapis.com/breadfast-staging/files/breadfast-staging/files/86ab758d1ad950d840de42471e74de04fd6ee8b70cdfd5b3539e8cae1efcc114_XXHDPI"
        let input = "https:/storage.googleapis.com/breadfast-staging/files/breadfast-staging/files/86ab758d1ad950d840de42471e74de04fd6ee8b70cdfd5b3539e8cae1efcc114"
        test(expectedResult, input)
    }
    
    func testWithResolutionInImageURL() {
        let expectedResult = "https://cdn.breadfast.com/wp-content/uploads/2023/10/SC-Bakeries-300x300_XXHDPI.png"
        let input = "https://cdn.breadfast.com/wp-content/uploads/2023/10/SC-Bakeries-300x300.png"
        test(expectedResult, input)
    }
    
    private func test(_ expectedResult: String, _ input: String) {
        let imageResource = RemoteImageResource(
            path: input,
            placeholder: .init(systemName: "paperplane.fill"),
            deviceScale: .xxHDPI
        )
        XCTAssertNotNil(imageResource.url)
        XCTAssertEqual(expectedResult, imageResource.url?.absoluteString ?? "")
    }
}
