//
//  FontsGeneratorTests.swift
//  
//
//  Created by Jean-Charles Neboit on 17/03/2021.
//

import Foundation

import XCTest
import TSCUtility
@testable import SwiftyAssets

final class FontsGeneratorTests: AbstractXCTestCase {
    // MARK: - Properties
    private var sut: FontsGenerator!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        
        var commandRegistry = CommandRegistry(usage: CommandLineTool.usage, overview: CommandLineTool.overview)
        commandRegistry.register(command: FontsCommand.self)
        let parser = commandRegistry.parser
        
        let input = resourcesDirectory.appendingPathComponent("Fonts/apple_garamond", isDirectory: true).path
        let result = try! parser.parse(["fonts", input, "output ."])
        
        sut = try! FontsGenerator(result: result, command: .init(parser: parser))
    }
    
    // MARK: - Tests
    func testColorsGeneration() {
        try! sut.generate()
    }
}
