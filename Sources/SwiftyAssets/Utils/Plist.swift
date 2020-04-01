//
//  Plist.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 01/04/2020.
//

import Foundation

class Plist {
    func getPlist(withName name: String) -> [String]?
    {
        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }

        return nil
    }
}
