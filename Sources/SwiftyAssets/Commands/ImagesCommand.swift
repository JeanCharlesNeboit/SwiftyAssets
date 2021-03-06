//
//  ImagesCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

public class ImagesCommand: AssetsCommand, Command {
    // MARK: - Properties
    public let command: String = "images"
    public let overview: String = "Generate Images"
    
    // MARK: - Options
    private var imagesFolderPathOption: OptionArgument<String>?
    
    // MARK: - Initialization
    public required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
        imagesFolderPathOption = subparser.addOption(option: .resources)
    }
    
    // MARK: - Run
    public func run(with result: ArgumentParser.Result) throws {
        let generator = try ImagesGenerator(result: result, command: self)
        try generator?.generate()
    }
}

// MARK: - ArgumentParser.Result
extension ImagesCommand {
    func imagesFolderPath(in result: ArgumentParser.Result) -> String? {
        guard let path = imagesFolderPathOption else { return nil }
        return result.get(path)
    }
}
