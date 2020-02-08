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
    
    init(input: String, output: String) throws {
        self.csv = try CSV(url: URL(fileURLWithPath: input))
    }
}
