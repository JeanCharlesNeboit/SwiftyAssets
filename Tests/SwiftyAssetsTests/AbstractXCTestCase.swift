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
        return URL(fileURLWithPath: #file).deletingLastPathComponent()
    }

    var resourcesDirectory: URL {
        return testsDirectory.appendingPathComponent("Resources")
    }

    func getURLInResources(path: String, ext: Extension) -> URL {
        return resourcesDirectory.appendingPathComponent(path).appendingPathExtension(ext.withoutDot)
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
