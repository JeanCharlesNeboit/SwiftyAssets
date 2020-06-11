//
//  ColorsYALMParserTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 09/06/2020.
//

import XCTest
@testable import SwiftyAssets

final class ColorsYALMParserTests: AbstractXCTestCase {
    func testParseColorsWithCleanFile() {
        let cleanFile = resourcesDirectory.appendingPathComponent("clean_colors").appendingPathExtension("yml")
        
        let names = ["primary", "secondary"]
        let lightColors = ["#c9121e", "#c9121e"]
        let darkColors = [nil, "#f2b500"]
        
        do {
            sleep(1)
            let sut = try ColorsYAMLParser(path: cleanFile.path)
            
            XCTAssertEqual(sut.colors.count, 2)
            
            var colors = sut.colors
            colors.sort { (lhs, rhs) -> Bool in lhs.name < rhs.name }
            
            for (i, color) in colors.enumerated() {
                XCTAssertEqual(color.name, names[i])
                XCTAssertEqual(color.light.toHex, lightColors[i])
                XCTAssertEqual(color.dark?.toHex, darkColors[i])
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testParseColorsWithWrongFileWithBadHex() {
        let wrongFile = resourcesDirectory.appendingPathComponent("wrong_colors").appendingPathExtension("yml")
        
        XCTAssertThrowsError(try ColorsYAMLParser(path: wrongFile.path)) { error in
            XCTAssertEqual(error as? ColorParserError, ColorParserError.badHex)
        }
    }
}
