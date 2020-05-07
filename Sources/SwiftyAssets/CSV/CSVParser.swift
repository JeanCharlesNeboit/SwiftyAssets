//
//  CSVParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SwiftCSV

class CSVParser {
    let csv: CSV
    
    init(path: String) throws {
        self.csv = try CSV(url: URL(fileURLWithPath: path))
    }
}
