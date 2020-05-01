//
//  ImagesGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 14/02/2020.
//

import Foundation
import SPMUtility

class ImagesGenerator: AssetsGenerator {
    private var csvParser: ImagesCSVParser?
    private var imagesFolderPath: String?
    
    init?(result: ArgumentParser.Result, command: ImagesCommand) throws {
        try super.init(result: result, assetsCommand: command)
        
        self.csvParser = try ImagesCSVParser(input: input, output: output)
        imagesFolderPath = command.imagesFolderPath(in: result)
    }
    
    override func generate() throws {
        try super.generate()
        try createImagesXCAssets()
    }
    
    private func createImagesXCAssets() throws {
        let xcassetsPath = "\(output)/\(Spec.projectName)\(Extension.xcassets.rawValue)/Images"
        
        guard let images = csvParser?.images,
            let imagesFolderPath = imagesFolderPath,
            let imagesInputURL = URL(string: imagesFolderPath),
            var outputURL = URL(string: output) else {
            return
        }
        
        var imagesPath: [String] = []
        if let enumerator = FileManager.default.enumerator(at: imagesInputURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                print("DirectoryEnumerator error at \(url): ", error)
                return true
            }) {
            
            for case let fileURL as Foundation.URL in enumerator {
                if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileURL.pathExtension as CFString, nil) {
                    if UTTypeConformsTo(uti.takeRetainedValue(), kUTTypeScalableVectorGraphics) {
                        imagesPath.append(fileURL.path)
                    }
                }
            }
        }
        
        let formatOption = "png"
        for image in images {
            guard let imagePath = imagesPath.first(where: { $0.contains("\(image.name)") }),
                let imageURL = URL(string: imagePath),
                image.width != nil || image.height != nil else {
                return
            }
            
            let process = Process()
            let outputPipe = Pipe()
            let errorPipe = Pipe()
            
            process.executableURL = URL(fileURLWithPath: "/usr/local/bin/rsvg-convert")
            process.arguments = ["--format", formatOption]
            process.standardOutput = outputPipe
            process.standardError = errorPipe
            
            if let width = image.width {
                process.arguments?.append("--width")
                process.arguments?.append("\(width)")
            }
            
            if let height = image.height {
                process.arguments?.append("--height")
                process.arguments?.append("\(height)")
            }
            
            var generatedImageName = imageURL
            generatedImageName.deletePathExtension()
            generatedImageName.appendPathExtension(formatOption)
            
            var generatedImageURL = outputURL
            generatedImageURL.appendPathComponent(generatedImageName.lastPathComponent)
            
            process.arguments?.append("\(imageURL.path)")
            process.arguments?.append("-o")
            process.arguments?.append("\(generatedImageURL.path)")
            
            //print(process.arguments?.joined(separator: " "))
            
            do {
                try process.run()
                process.waitUntilExit()
                
                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(decoding: outputData, as: UTF8.self)
                if !output.isEmpty {
                    print(output)
                }
                
                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                let error = String(decoding: errorData, as: UTF8.self)
                if !error.isEmpty {
                    print(error)
                }
            } catch let error {
                print(error)
            }
        }
    }
}
