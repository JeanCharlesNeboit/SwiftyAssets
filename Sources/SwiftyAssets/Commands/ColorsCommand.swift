//
//  ColorsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import ArgumentParser

struct ColorsCommand: ParsableCommand, AssetsCommand {
    static var configuration = CommandConfiguration(
        commandName: "colors",
        abstract: "A utility for generating named colors.",
        version: "1.0.0"
    )
        
    // MARK: - Properties
    @Argument(help: "The path of the colors input file.")
    var input: String
    
    @Argument(help: "The path where files will be generated.")
    var output: String
    
    @Option(name: .shortAndLong, help: "Specify the input file extension (default 'yaml').")
    var inputFileType: String = InputFileType.yaml.ext
    
    @OptionGroup var projectOptions: ProjectOptions
    
    // MARK: - Run
    mutating func run() throws {
        let generator = try ColorsGenerator(command: self)
        try generator?.generate()
    }
}
