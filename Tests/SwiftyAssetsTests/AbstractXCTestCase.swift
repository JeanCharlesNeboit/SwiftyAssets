//
//  AbstractXCTestCase.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 02/05/2020.
//

import XCTest
import class Foundation.Bundle

class AbstractXCTestCase: XCTestCase {
    var testsDirectory: URL {
        return URL(fileURLWithPath: #file).deletingLastPathComponent()
    }
    
    var resourcesDirectory: URL {
        return testsDirectory.appendingPathComponent("Resources")
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
