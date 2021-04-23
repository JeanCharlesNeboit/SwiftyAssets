//
//  ContentView.swift
//  Example
//
//  Created by Jean-Charles Neboit on 01/10/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center) {
            SwiftyAssets.Images.apple1
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            Text(SwiftyAssets.Strings.think_different)
                .font(SwiftyAssets.Font.AppleGaramond.regular.font(withSize: 34, relativeTo: .largeTitle))
                .foregroundColor(SwiftyAssets.Colors.think_different)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
