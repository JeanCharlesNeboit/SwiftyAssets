//
//  PlistService.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 01/04/2020.
//

import Foundation

class Plist {
    var content: [String: Any] = [:]
}

class PlistService {
    // MARK: - Static Properties
    static let FontsProvidedByAppKey = "Fonts provided by application"

    // MARK: - Properties
    var path: String
    
    // MARK: - Initialization
    init(path: String) {
        self.path = path
    }

    // MARK: - PropertyList
    func read() -> [String: Any]? {
        if let xml = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String: Any]
        }

        return nil
    }
    
    func write(dict: [String: Any]) throws {
        guard let url = URL(string: "file://\(path)") else {
            return
        }
            
        let plistData = try PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
        try plistData.write(to: url)
    }
}
