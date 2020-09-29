//
//  StringsYAMLParserTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 23/09/2020.
//

import XCTest
@testable import SwiftyAssets

final class StringsYAMLParserTests: AbstractXCTestCase {
    func testParseStrings_CleanFile() {
        let cleanFile = getURLInResources(path: "Strings/clean_strings", ext: .yaml)
        
        let expected = ["en_GB": [("apple", "Apple"), ("coffee", "Coffee")],
                        "fr_FR": [("apple", "Pomme"), ("coffee", "Café")]]
        let expectedKeys = expected.map { $0.key }.sorted()

        do {
            sleep(1)
            let sut = try StringsYAMLParser(path: cleanFile.path)
            let sortedLocalizableStrings = sut.localizableStrings.sorted( by: { $0.0 < $1.0 })

            XCTAssertEqual(sut.localizableStrings.count, 2)
            sortedLocalizableStrings.enumerated().forEach { iterator1 in
                let key = iterator1.element.key
                let translations = iterator1.element.value.sorted()
                
                XCTAssertEqual(key.id, expectedKeys[iterator1.offset])
                XCTAssertEqual(translations.count, expected[key.id]?.count)
                
                translations.enumerated().forEach { iterator2 in
                    XCTAssertEqual(iterator2.element.key, expected[key.id]?[iterator2.offset].0)
                    XCTAssertEqual(iterator2.element.value, expected[key.id]?[iterator2.offset].1)
                }
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
