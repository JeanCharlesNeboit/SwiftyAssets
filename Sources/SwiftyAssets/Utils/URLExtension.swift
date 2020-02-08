//
//  URLExtension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

extension URL {
    var isDirectory: Bool {
        let values = try? resourceValues(forKeys: [.isDirectoryKey])
        return values?.isDirectory ?? false
    }
}
