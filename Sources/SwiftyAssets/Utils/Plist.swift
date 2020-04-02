//
//  PlistService.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 01/04/2020.
//

import Foundation

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
    func read() -> [String: Any]?
    {
        if let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String: Any]
        }

        return nil
    }
    
    func write(dict: [String: Any]) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        do {
            let data = try encoder.encode(dict)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
}
