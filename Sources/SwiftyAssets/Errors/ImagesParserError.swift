//
//  ImagesParserError.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 11/06/2020.
//

import Foundation

enum ImagesParserError: Error {
    case noDimensions(key: String)
    case badDimensions
    case badFormat(key: String)
}

extension ImagesParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDimensions(let key):
            return "Image must at least has width or heigth, and size must be greater than 0 for key '\(key)'"
        case .badDimensions:
            return "Unable to decode image dimension."
        case .badFormat(let key):
            return "Bad format for image with key '\(key)'"
        }
    }
}
