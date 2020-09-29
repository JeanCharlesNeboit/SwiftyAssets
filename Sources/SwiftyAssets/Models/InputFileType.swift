//
//  InputFileType.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 29/09/2020.
//

import Foundation

enum InputFileType: CaseIterable {
    case yaml
    case csv
    
    init?(ext: String) {
        if let type = InputFileType.allCases.first(where: { $0.ext == ext }) {
            self = type
            return
        }
        return nil
    }
    
    var ext: String {
        switch self {
        case .yaml:
            return Extension.yaml.rawValue
        case .csv:
            return Extension.csv.rawValue
        }
    }
}
