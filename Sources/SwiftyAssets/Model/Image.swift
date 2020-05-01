//
//  Image.swift
//  Basic
//
//  Created by Jean-Charles Neboit on 15/04/2020.
//

import Foundation

struct Image {
    let name: String
    let width: Int?
    let height: Int?
}

extension Image {
    enum Scale: String {
        case x1 = "@1x"
        case x2 = "@2x"
        case x3 = "@3x"
    }
}
