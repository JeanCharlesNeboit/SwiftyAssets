//
//  DescriptionError.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation

protocol LocalizedDescriptionError: Error {
    var localizedDescription: String { get }
}
