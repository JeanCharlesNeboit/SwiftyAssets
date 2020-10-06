//
//  ExampleApp.swift
//  Example
//
//  Created by Jean-Charles Neboit on 01/10/2020.
//

import UIKit
import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                printLoadedFonts()
            }
        }
    }
    
    private func printLoadedFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}
