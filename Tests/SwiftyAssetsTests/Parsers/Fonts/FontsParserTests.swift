//
//  FontsParserTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 30/07/2020.
//

import XCTest
@testable import SwiftyAssets

final class FontsParserTests: AbstractXCTestCase {
    func testParseFonts() {
        let fontDirectory = resourcesDirectory.appendingPathComponent("Fonts/apple_garamond", isDirectory: true)
        
        do {
            sleep(1)
            let sut = try FontsParser(path: fontDirectory.path)
            XCTAssertEqual(sut.fontsGroupedByFamily.count, 2)
            XCTAssertEqual(sut.fontsGroupedByFamily["Apple Garamond"]?.count, 4)
            XCTAssertEqual(sut.fontsGroupedByFamily["Apple Garamond Light"]?.count, 2)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    #warning("Check plist in a folder with space in name (eg: Supporting Files. Bug seems appear")
}
