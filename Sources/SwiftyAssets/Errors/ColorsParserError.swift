//
//  ColorParserError.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 10/06/2020.
//

import Foundation

enum ColorParserError: Error {
    case badHexColor
}

extension ColorParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badHexColor:
            return NSLocalizedString("Unable to decode hex color.", comment: "BadHexColor")
        }
    }
}
