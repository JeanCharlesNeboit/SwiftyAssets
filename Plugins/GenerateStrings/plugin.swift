//
//  GenerateStringsPlugin.swift
//  
//
//  Created by Jean-Charles Neboit on 08/07/2022.
//

import PackagePlugin

@main
struct GenerateStringsPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        debugPrint(context)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension GenerateStringsPlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        debugPrint(context)
    }
}
#endif
