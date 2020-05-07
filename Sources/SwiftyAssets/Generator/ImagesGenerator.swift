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
    private var imagesPath: [String] = []
    
    let formatOption = "png"
    
    init?(result: ArgumentParser.Result, command: ImagesCommand) throws {
        try super.init(result: result, assetsCommand: command)
        
        self.csvParser = try ImagesCSVParser(path: input)
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
        let xcassetsPath = "\(output)/\(Spec.projectName)\(Extension.xcassets.rawValue)/Images"
        
        guard let images = csvParser?.images else { return }
        
        for image in images {
            guard let imagePath = imagesPath.first(where: { $0.contains("\(image.name)") }),
                !image.name.isEmpty && !image.name.starts(with: "//"),
                image.width != nil || image.height != nil else {
                return
            }
            
            let imagesetFolder = "\(xcassetsPath)/\(image.name)\(Extension.imageset.rawValue)"
            try FileManager.default.createDirectory(atPath: imagesetFolder, withIntermediateDirectories: true, attributes: nil)
            try self.generateImageset(with: image, from: imagePath, to: imagesetFolder)
        }
        
        try self.generateSwiftFile(images: images)
    }
    
    private func generateImageset(with image: Image, from inputPath: String, to outputPath: String) throws {
        let filename = "Contents"
        
        var info = AssetsSet.info
        info.appendToLast(newElement: ",")
        
        Image.Scale.allCases.forEach { scale in
            var arguments = ["--format", formatOption]
            
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
            arguments.append("\(outputPath)/\(image.name(with: scale)).\(formatOption)")
            
            generatePNG(with: arguments)
        }
        
        var lines = ["{"]
        lines.append(contentsOf: info)
        lines.append(contentsOf: image.json(ext: formatOption))
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
    
    private func generateSwiftFile(images: [Image]) throws {
        let filename = "SwiftyImages"
        
        var lines = [
            "",
            "import UIKit",
            "",
            "extension \(Spec.projectName) {",
            "\tclass Images {"
        ]
        
        for image in images {
            guard !image.name.isEmpty else { return }
            
            if image.name.starts(with: "//") {
                lines.append("\(String(repeating: "\t", count: 2))\(image.name.replacingOccurrences(of: "//", with: "// MARK: -"))")
            } else {
                lines.append(contentsOf: [
                    "\(String(repeating: "\t", count: 2))static var \(image.name): UIImage {",
                    "\(String(repeating: "\t", count: 3))return UIImage(named: \"\(image.name)\")!",
                    "\(String(repeating: "\t", count: 2))}",
                    ""
                ])
            }
        }
        
        lines.append(contentsOf: [
            "\t}",
            "}"
        ])
        
        let fileGenerator = FileGenerator(filename: filename, ext: .swift, fileHeader: getFileHeader(), lines: lines)
        try fileGenerator.generate(atPath: output)
    }
}
