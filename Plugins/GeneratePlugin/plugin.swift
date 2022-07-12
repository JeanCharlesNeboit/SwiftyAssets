//
//  GenerateStringsPlugin.swift
//  
//
//  Created by Jean-Charles Neboit on 08/07/2022.
//

import Foundation
import PackagePlugin

@main
struct GeneratePlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return []
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension GeneratePlugin: XcodeBuildToolPlugin {
    private var fileManager: FileManager {
        FileManager.default
    }

    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let executable = try context.tool(named: "SwiftyAssetsCLI").path
        let project = context.xcodeProject.directory
        let plugin = context.pluginWorkDirectory
        let input = project.appending(subpath: "SwiftyAssets")
        let output = plugin.appending(subpath: "Resources")

        print("Plugin work directory: \(context.pluginWorkDirectory.string)")

        return [
            generateStrings(
                executable: executable,
                input: input,
                output: output,
                projectName: context.xcodeProject.displayName
            )
        ].compactMap { $0 }
    }

    private func generateStrings(executable: Path, input: Path, output: Path, projectName: String) -> Command? {
        let stringsFile = input.appending("strings.yml")
        guard fileManager.fileExists(atPath: stringsFile.string) else {
            return nil
        }

        return .prebuildCommand(
            displayName: "Generate localizable strings",
            executable: executable,
            arguments: [
                "strings",
                stringsFile.string,
                output.string,
                "--project-name",
                projectName
            ],
            outputFilesDirectory: output
        )
    }
}
#endif
