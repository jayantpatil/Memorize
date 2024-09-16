//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Jayant D Patil on 14/09/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        @StateObject var game = EmojiMemoryGame()
        
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
