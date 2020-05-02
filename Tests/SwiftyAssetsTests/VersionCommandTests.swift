//
//  VersionCommandTests.swift
//  SwiftyAssetsTests
//
//  Created by Jean-Charles Neboit on 02/05/2020.
//

import XCTest
import class Foundation.Bundle
//@testable import SwiftyAssets

final class VersionCommandTests: SwiftyAssetsTests {
    // MARK: - SwiftyAssets --version
    func testVersionCommand() throws {
        let binary = productsDirectory.appendingPathComponent("SwiftyAssets")
        
        let process = Process()
        process.executableURL = binary
        process.arguments = ["--version"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
        
        XCTAssertEqual(output, VersionCommand().appVersion)
    }
    
    static var allTests = [
        ("testVersionCommand", testVersionCommand),
    ]
}


