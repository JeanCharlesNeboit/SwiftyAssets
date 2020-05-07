//
//  ColorsCSVParserTests.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 03/05/2020.
//

import XCTest
@testable import SwiftyAssets

final class ColorsCSVParserTests: AbstractXCTestCase {
    func testRetrieveExpectedColors() {
        let cleanColorsCSV = resourcesDirectory.appendingPathComponent("clean_colors").appendingPathExtension("csv")
        let names = ["primary", "secondary"]
        let lightColors = ["#c9121e", "#c9121e"]
        let darkColors = [nil, "#f2b500"]
        
        do {
            sleep(1)
            let sut = try ColorsCSVParser(path: cleanColorsCSV.path)
            
            XCTAssertEqual(sut.colors.count, 2)
            for (i, color) in sut.colors.enumerated() {
                XCTAssertEqual(color.name, names[i])
                XCTAssertEqual(color.lightHex, lightColors[i])
                XCTAssertEqual(color.darkHex, darkColors[i])
            }
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRetrieveExpectedColorsAndComments() {
        let cleanColorsCSV = resourcesDirectory.appendingPathComponent("clean_colors_with_comments").appendingPathExtension("csv")
        
        do {
            sleep(1)
            let sut = try ColorsCSVParser(path: cleanColorsCSV.path)
            
            XCTAssertEqual(sut.colors.count, 2)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    static var allTests = [
        ("testVersionCommand", testRetrieveExpectedColors),
    ]
}
