//
//  Spec.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 06/02/2020.
//

import Foundation

public struct CommandLineTool {
    public static let name = "SwiftyAssets"
    public static let usage = "[--version] [--help] <command> <options>"
    public static let overview = "\(CommandLineTool.name) is an open source Command Line Tool used to generate iOS, WatchOS, macOS & tvOS assets."
    public static let version = "v0.0.1"
}
