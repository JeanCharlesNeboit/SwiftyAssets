//
//  AbstractXCTestCase.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 02/05/2020.
//

import XCTest
import class Foundation.Bundle
@testable import SwiftyAssets

class AbstractXCTestCase: XCTestCase {
    var testsDirectory: URL {
        URL(fileURLWithPath: #file).deletingLastPathComponent()
    }

    var resourcesDirectory: URL {
        testsDirectory.appendingPathComponent("Resources")
    }
    
    var generatedDirectory: URL {
        testsDirectory.appendingPathComponent("Generated")
    }

    func getResourceURL(path: String, ext: Extension) -> URL {
        resourcesDirectory.appendingPathComponent(path).appendingPathExtension(ext.withoutDot)
    }
    
    func getResourceURLString(path: String, ext: Extension) -> String {
        resourcesDirectory
            .appendingPathComponent(path)
            .appendingPathExtension(ext.withoutDot)
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
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
