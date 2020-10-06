//
//  ContentView.swift
//  Example
//
//  Created by Jean-Charles Neboit on 01/10/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(" \(SwiftyAssets.Strings.apple)")
            .font(SwiftyAssets.Font.AppleGaramond.regular.font(withSize: 34, relativeTo: .largeTitle))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
