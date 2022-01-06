//
//  ImagesCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import ArgumentParser

struct ImagesCommand: ParsableCommand, AssetsCommand {
    static var configuration = CommandConfiguration(
        commandName: "images",
        abstract: "A utility for generating images.",
        version: "1.0.0"
    )
    
    // MARK: - Properties
    @Argument(help: "The path of the images input file.")
    var input: String
    
    @Argument(help: "The path where files will be generated.")
    var output: String
    
    @Option(name: .shortAndLong, help: "Specify the xcassets folder path.")
    var resources: String?
    
    @OptionGroup var projectOptions: ProjectOptions
    
    // MARK: - Run
    public func run() throws {
        let generator = try ImagesGenerator(command: self)
        try generator?.generate()
    }
}
