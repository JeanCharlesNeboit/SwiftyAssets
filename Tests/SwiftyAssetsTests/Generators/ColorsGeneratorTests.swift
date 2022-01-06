//
//  ColorsGeneratorTests.swift
//  
//
//  Created by Jean-Charles Neboit on 16/03/2021.
//

import XCTest
@testable import SwiftyAssets

final class ColorsGeneratorTests: AbstractXCTestCase {
    // MARK: - Properties
    private var sut: ColorsGenerator!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let input = getResourceURL(path: "Colors/clean_colors", ext: .yaml).path
        sut = try? ColorsGenerator(command: .parse([input, "."]), underTest: true)
    }
    
    // MARK: - Tests
    func testColorsGeneration() {
        // Given
        
        // When
        try! sut.generate()
        
        // Expect
        print(sut.generatedFileContent)
        XCTAssertEqual(sut.colors.count, 2)
        XCTAssertNotEqual(sut.generatedFileContent, "")
    }
}
