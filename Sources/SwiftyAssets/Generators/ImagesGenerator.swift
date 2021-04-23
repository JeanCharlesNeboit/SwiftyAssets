//
//  ImagesGenerator.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 14/02/2020.
//

import Foundation
import TSCUtility

class ImagesGenerator: AssetsGenerator {
    private var images = [ImageSet]()
    private var imagesFolderPath: String?
    private var imagesPath: [String] = []
    
    init?(result: ArgumentParser.Result, command: ImagesCommand, underTest: Bool = false) throws {
        try super.init(result: result, assetsCommand: command, underTest: underTest)
        
//        if let csvParser = try? ImagesCSVParser(path: input),
//            images.count != 0 {
//            self.images = csvParser.images
//        }
        
        do {
            let yamlParser = try ImagesYAMLParser(path: input)
            self.images = yamlParser.images
        } catch {
            log.error(message: error.localizedDescription)
        }
        imagesFolderPath = command.imagesFolderPath(in: result)
    }
    
    override func generate() throws {
        try super.generate()
        imagesPath = getImagesPaths()
        try generateImages()
    }
    
    private func getImagesPaths() -> [String] {
        var paths: [String] = []
        
        guard let imagesFolderPath = imagesFolderPath,
            let imagesInputURL = URL(string: imagesFolderPath) else {
                return imagesPath
        }
        
        if let enumerator = FileManager.default.enumerator(at: imagesInputURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                print("DirectoryEnumerator error at \(url): ", error)
                return true
            }) {
            
            for case let fileURL as Foundation.URL in enumerator {
                if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileURL.pathExtension as CFString, nil) {
                    if UTTypeConformsTo(uti.takeRetainedValue(), kUTTypeScalableVectorGraphics) {
                        paths.append(fileURL.path)
                    }
                }
            }
        }
        
        return paths
    }
    
    private func generateImages() throws {
        let xcassetsPath = "\(output)/\(CommandLineTool.name)\(Extension.xcassets.rawValue)/Images"
        
        for image in images {
            guard let imagePath = imagesPath.first(where: { $0.contains("\(image.name)") }),
                !image.name.isEmpty && !image.name.starts(with: "//") else {
                return
            }
            
            let imagesetFolder = "\(xcassetsPath)/\(image.name)\(Extension.imageset.rawValue)"
            try FileManager.default.createDirectory(atPath: imagesetFolder, withIntermediateDirectories: true, attributes: nil)
            try self.generateImageset(with: image, from: imagePath, to: imagesetFolder)
        }
        
        try self.generateSwiftFile(images: images)
    }
    
    private func generateImageset(with image: ImageSet, from inputPath: String, to outputPath: String) throws {
        let filename = "Contents"
        
        var info = AssetsSet.info
        info.appendToLast(newElement: ",")
        
        let fileExtension = image.format.fileExtension
        if image.isSingleScale {
            Process.shell(launchPath: "/bin/cp", arguments: [inputPath, "\(outputPath)/\(image.formattedName())\(fileExtension())"])
        } else {
            ImageSet.Scale.allCases.forEach { scale in
                var arguments = ["--format", fileExtension.withoutDot]
                
                if let width = image.width {
                    arguments.append("--width")
                    arguments.append("\(width * scale.multiplier)")
                }
        
                if let height = image.height {
                    arguments.append("--height")
                    arguments.append("\(height * scale.multiplier)")
                }
                
                arguments.append("\(inputPath)")
                arguments.append("-o")
                arguments.append("\(outputPath)/\(image.formattedName(with: scale))\(fileExtension())")
                
                generatePNG(with: arguments)
            }
        }
        
        var lines = ["{"]
        lines.append(contentsOf: info)
        lines.append(contentsOf: image.json(ext: fileExtension()))
        lines.append("}")
        
        let fileGenerator = FileGenerator(filename: filename, ext: .json, fileHeader: nil, lines: lines)
        try fileGenerator.generate(atPath: outputPath)
    }
    
    private func generatePNG(with arguments: [String]) {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/rsvg-convert")
        process.arguments = arguments
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
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
    
    private func generateSwiftFile(images: [ImageSet]) throws {
        try generateSwiftFile(templateName: "images", filename: "SwiftyImages", additionalContext: [
            "images": images
        ])
    }
}
