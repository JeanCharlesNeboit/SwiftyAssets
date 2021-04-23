//
//  ImagesYAMLParserTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 11/06/2020.
//

import XCTest
@testable import SwiftyAssets

final class ImagesYAMLParserTests: AbstractXCTestCase {
    // MARK: - Tests
    func testParseSingleImage() throws {
        // Given
        let sut = try ImagesYAMLParser(yaml: """
        github:
            width: 24
        """)
        
        // When
        let image = sut.images.first!
        
        // Then
        XCTAssertEqual(sut.images.count, 1)
        XCTAssertEqual(image.name, "github")
        XCTAssertEqual(image.format, .png)
        XCTAssertEqual(image.width, 24)
        XCTAssertEqual(image.height, nil)
    }
    
    func testParseMultipleImages() throws {
        // Given
        let sut = try ImagesYAMLParser(yaml: """
        iPhone:
            width: 24

        iPad:
            height: 48
        """)
        
        // When
        // sut.images is not ordered like in yaml declaration
        let iPhoneImage = sut.images.first(where: { $0.name == "iPhone" })!
        let iPadImage = sut.images.first(where: { $0.name == "iPad" })!
        
        // Then
        XCTAssertEqual(sut.images.count, 2)
        XCTAssertEqual(iPhoneImage.format, .png)
        XCTAssertEqual(iPadImage.format, .png)
        XCTAssertEqual(iPhoneImage.width, 24)
        XCTAssertEqual(iPadImage.height, 48)
        XCTAssertEqual(iPhoneImage.height, nil)
        XCTAssertEqual(iPadImage.width, nil)
    }
    
    func testParseNegativeSize() {
        // Given
        XCTAssertThrowsError(try ImagesYAMLParser(yaml: """
        iPhone:
            width: -1
        """)) { error in
            var assert = false
            if case ImagesParserError.badDimensions = error {
                assert = true
            }
            XCTAssertTrue(assert)
        }
    }
    
    func testParseSingleImageAsSVG() throws {
        // Given
        let sut = try ImagesYAMLParser(yaml: """
        github:
            format: svg
        """)
        
        // When
        let image = sut.images.first!
        
        // Then
        XCTAssertEqual(sut.images.count, 1)
        XCTAssertEqual(image.name, "github")
        XCTAssertEqual(image.format, .svg)
        XCTAssertEqual(image.width, nil)
        XCTAssertEqual(image.height, nil)
    }
    

//    func testParseImages_WrongFileWithNoDimensionsError() {
//        let wrongFile = getResourceURL(path: "Images/wrong_images_no_dimensions", ext: .yaml)
//
//        XCTAssertThrowsError(try ImagesYAMLParser(path: wrongFile.path)) { error in
//            XCTAssertEqual(error as? ImagesParserError, ImagesParserError.noDimensions)
//        }
//    }
//
//    func testParseImagesWithWrongFileWithBadDimensionsError() {
//        XCTAssertThrowsError(try ImagesYAMLParser(yaml: """
//        github:
//        """)
//        ) { error in
//            XCTAssertEqual(error as? ImagesParserError, ImagesParserError.badDimensions)
//        }
//    }
}
