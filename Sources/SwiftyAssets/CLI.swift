//
//  AssetsCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 06/01/2022.
//

import Foundation
import ArgumentParser

public struct CLI: ParsableCommand {
    public static var name = "SwiftyAssets"
    public static var configuration = CommandConfiguration(
        commandName: "swiftyassets",
        abstract: "SwiftyAssets is an open source command line interface used to generate iOS, WatchOS, macOS & tvOS assets.",
        version: "1.0.0",
        subcommands: [
            ColorsCommand.self,
            FontsCommand.self,
            ImagesCommand.self,
            StringsCommand.self
        ]
    )
    
    public init() {
        
    }
}
