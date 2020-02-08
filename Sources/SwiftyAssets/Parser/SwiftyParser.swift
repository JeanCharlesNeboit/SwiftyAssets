//
//  SwiftyParser.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 07/02/2020.
//

import Foundation
import SPMUtility

class SwiftyParser {
    let argumentParser: ArgumentParser
    let options: [Option: OptionArgument<String>]
    let positionals: [Positional: PositionalArgument<String>]
    let result: ArgumentParser.Result
    
    init?(argumentParser: ArgumentParser, args: [String]) throws {
        self.argumentParser = argumentParser
        options = argumentParser.addOptions()
        positionals = argumentParser.addPositionals()
        result = try argumentParser.parse(args)
    }
    
    var projectName: String? {
        return get(option: .projectName)?.appending("\n")
    }
    
    var copyright: String? {
        return get(option: .copyright)
    }
    
    private func get(option: Option) -> String? {
        guard let optionArgument = options[option],
            let value = result.get(optionArgument) else {
            return nil
        }
        
        return value
    }
}
