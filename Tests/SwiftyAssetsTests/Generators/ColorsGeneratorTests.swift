//
//  ColorsGeneratorTests.swift
//  
//
//  Created by Jean-Charles Neboit on 16/03/2021.
//

import XCTest
import TSCUtility
@testable import SwiftyAssets

final class ColorsGeneratorTests: AbstractXCTestCase {
    // MARK: - Properties
    private var sut: ColorsGenerator!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        
        var commandRegistry = CommandRegistry(usage: CommandLineTool.usage, overview: CommandLineTool.overview)
        commandRegistry.register(command: ColorsCommand.self)
        let parser = commandRegistry.parser
        
        let input = getResourceURL(path: "Colors/clean_colors", ext: .yaml).path
        let result = try! parser.parse(["colors", input, "output ."])
        
        sut = try! ColorsGenerator(result: result, command: .init(parser: parser))
    }
    
    // MARK: - Tests
    func testColorsGeneration() {
        try! sut.generate()
    }
}
