//
//  ImagesParserError.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 11/06/2020.
//

import Foundation

enum ImagesParserError: Error {
    case noDimensions
    case badDimensions
}

extension ImagesParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDimensions:
            return NSLocalizedString("Image must at least has width or heigth.", comment: "NoDimensions")
        case .badDimensions:
            return NSLocalizedString("Unable to decode image dimension.", comment: "BadDimensions")
        }
    }
}
