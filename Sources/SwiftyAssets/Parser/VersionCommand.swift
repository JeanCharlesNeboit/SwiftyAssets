//
//  VersionCommand.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 02/05/2020.
//

import Foundation

class VersionCommand {
    var appVersion: String {
        "\(Spec.projectName) \(Spec.version)"
    }
}
