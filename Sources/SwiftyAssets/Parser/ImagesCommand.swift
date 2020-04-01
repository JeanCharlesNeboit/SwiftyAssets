//
//  ImagesCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 13/02/2020.
//

import Foundation
import SPMUtility

class ImagesCommand: AssetsCommand, Command {
    let command: String = "images"
    let overview: String = "Generate Images"
    
    required init(parser: ArgumentParser) {
        super.init(parser: parser, command: command, overview: overview)
    }
    
    func run(with result: ArgumentParser.Result) throws {
//        let generator = try StringsGenerator(result: result, assetsCommand: self)
//        try generator?.generate()
    }
}
