//
//  DateFormatterExtension.swift
//  
//
//  Created by Jean-Charles Neboit on 16/03/2021.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        dateFormat = format
    }
}
