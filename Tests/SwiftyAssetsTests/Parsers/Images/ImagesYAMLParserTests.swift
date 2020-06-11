//
//  ImagesYAMLParserTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 11/06/2020.
//

import XCTest
@testable import SwiftyAssets

final class ImagesYAMLParserTests: AbstractXCTestCase {
    func testParseImagesWithCleanFile() {
        let cleanFile = resourcesDirectory.appendingPathComponent("clean_images").appendingPathExtension("yml")
        
        let names = ["github", "swift"]
        let widths = [24, nil]
        let heights = [nil, 24]
        
        do {
            sleep(1)
            let sut = try ImagesYAMLParser(path: cleanFile.path)
            
            var images = sut.images
            images.sort { (lhs, rhs) -> Bool in lhs.name < rhs.name }
            
            XCTAssertEqual(sut.images.count, 2)
            for (i, image) in sut.images.enumerated() {
                XCTAssertEqual(image.name, names[i])
                XCTAssertEqual(image.width, widths[i])
                XCTAssertEqual(image.height, heights[i])
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testParseImagesWithWrongFileWithNoDimensionsError() {
        let wrongFile = resourcesDirectory.appendingPathComponent("wrong_images_no_dimensions").appendingPathExtension("yml")
        
        XCTAssertThrowsError(try ImagesYAMLParser(path: wrongFile.path)) { error in
            XCTAssertEqual(error as? ImagesParserError, ImagesParserError.noDimensions)
        }
    }
    
    func testParseImagesWithWrongFileWithBadDimensionsError() {
        let wrongFile = resourcesDirectory.appendingPathComponent("wrong_images_bad_dimensions").appendingPathExtension("yml")
        
        XCTAssertThrowsError(try ImagesYAMLParser(path: wrongFile.path)) { error in
            XCTAssertEqual(error as? ImagesParserError, ImagesParserError.badDimensions)
        }
    }
}
