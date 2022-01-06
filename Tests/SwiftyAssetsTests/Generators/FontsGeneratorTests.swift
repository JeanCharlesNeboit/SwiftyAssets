//
//  FontsGeneratorTests.swift
//  
//
//  Created by Jean-Charles Neboit on 17/03/2021.
//

import Foundation

import XCTest
@testable import SwiftyAssets

final class FontsGeneratorTests: AbstractXCTestCase {
    // MARK: - Properties
    private var sut: FontsGenerator!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let input = resourcesDirectory.appendingPathComponent("Fonts/apple_garamond", isDirectory: true).path
        sut = try? FontsGenerator(command: .parse([input, "."]), underTest: true)
    }
    
    // MARK: - Tests
    func testColorsGeneration() {
        // Given
        
        // When
        try! sut.generate()
        
        // Expect
        XCTAssertEqual(sut.fontFamilies.count, 2)
        XCTAssertEqual(sut.fontFamilies.first(where: { $0.name == "AppleGaramond"})?.fonts.count, 4)
        XCTAssertEqual(sut.fontFamilies.first(where: { $0.name == "AppleGaramondLight"})?.fonts.count, 2)
    }
}
