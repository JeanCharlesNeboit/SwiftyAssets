//
//  ColorsCSVParserTests.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 03/05/2020.
//

import XCTest
@testable import SwiftyAssets

final class ColorsCSVParserTests: AbstractXCTestCase {
    func testParseColors_CleanFile() {
        let cleanFile = getURLInResources(path: "Colors/clean_colors", ext: .csv)

        let names = ["primary", "secondary"]
        let lightColors = ["#c9121e", "#c9121e"]
        let darkColors = [nil, "#f2b500"]

        do {
            sleep(1)
            let sut = try ColorsCSVParser(path: cleanFile.path)

            XCTAssertEqual(sut.colors.count, 2)
            for (i, color) in sut.colors.enumerated() {
                XCTAssertEqual(color.name, names[i])
                XCTAssertEqual(color.light.toHex, lightColors[i])
                XCTAssertEqual(color.dark?.toHex, darkColors[i])
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testParseColors_WrongFileWithBadHex() {
        let wrongFile = getURLInResources(path: "Colors/wrong_colors", ext: .csv)

        XCTAssertThrowsError(try ColorsCSVParser(path: wrongFile.path)) { error in
            XCTAssertEqual(error as? ColorParserError, ColorParserError.badHex)
        }
    }
}
