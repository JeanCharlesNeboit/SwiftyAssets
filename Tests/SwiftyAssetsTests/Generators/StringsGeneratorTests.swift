//
//  StringsGeneratorTests.swift
//  
//
//  Created by Jean-Charles Neboit on 06/01/2022.
//

import XCTest
@testable import SwiftyAssets

final class StringsGeneratorTests: AbstractXCTestCase {
    // MARK: - Properties
    private var sut: StringsGenerator!
    private var stringsGeneratedDirectory: URL {
        generatedDirectory.appendingPathComponent("Strings")
    }
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let input = getResourceURL(path: "Strings/clean_strings", ext: .yaml).path
        sut = try? StringsGenerator(command: .parse([input, stringsGeneratedDirectory.absoluteString]), underTest: true)
    }
    
    // MARK: - Tests
    func testColorsGeneration() {
        // Given
        
        // When
        try! sut.generate()
        
        // Expect
        print(sut.generatedFileContent)
    }
}
