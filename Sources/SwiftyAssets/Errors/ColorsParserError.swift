//
//  ColorParserError.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 10/06/2020.
//

import Foundation

enum ColorParserError: Error {
    case badHex
}

extension ColorParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badHex:
            return NSLocalizedString("Unable to decode color hex.", comment: "badHex")
        }
    }
}
