//
//  FontsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import ArgumentParser

struct FontsCommand: ParsableCommand, AssetsCommand {
    static var configuration = CommandConfiguration(
        commandName: "fonts",
        abstract: "A utility for generating fonts.",
        version: "1.0.0"
    )
    
    // MARK: - Properties
    @Argument(help: "The folder where fonts are located.")
    var input: String
    
    @Argument(help: "The path where files will be generated.")
    var output: String
    
    @Option(name: .shortAndLong, help: "Specify the plist file path.")
    var plist: String?
    
    @OptionGroup var projectOptions: ProjectOptions
    
    // MARK: - Run
    mutating func run() throws {
        let generator = try FontsGenerator(command: self)
        try generator?.generate()
    }
}
