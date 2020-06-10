//
//  ColorsYALMParserTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 09/06/2020.
//

import XCTest
@testable import SwiftyAssets

class ColorsYALMParserTests: AbstractXCTestCase {
    func testParseColorsWithCleanColorsFile() {
        let cleanColorsCSV = resourcesDirectory.appendingPathComponent("clean_colors").appendingPathExtension("yml")
        let names = ["primary", "secondary"]
        let lightColors = ["#c9121e", "#c9121e"]
        let darkColors = [nil, "#f2b500"]
        
        do {
            sleep(1)
            let sut = try ColorsYAMLParser(path: cleanColorsCSV.path)
            
            XCTAssertEqual(sut.colors.count, 2)
            sut.colors.sort { (lhs, rhs) -> Bool in lhs.name < rhs.name }
            for (i, color) in sut.colors.enumerated() {
                XCTAssertEqual(color.name, names[i])
                XCTAssertEqual(color.light.toHex, lightColors[i])
                XCTAssertEqual(color.dark?.toHex, darkColors[i])
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    static var allTests = [
        ("testParseColorsWithCleanColorsFile", testParseColorsWithCleanColorsFile),
    ]
}
