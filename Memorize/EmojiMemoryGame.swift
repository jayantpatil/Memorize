//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jayant D Patil on 16/09/24.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    
    private static let emojis = ["🏎️", "🚓", "✈️", "🚀", "🚗", "🚌", "🛶", "🛸"]
    
    @Published private var model = createMemorizeGame()
    
    private static func createMemorizeGame() -> MemorizeGame<String> {
        MemorizeGame(numberOfPairsOfCards: 8) { pairIndex in
            guard emojis.indices.contains(pairIndex) else {
                return "⁉️"
            }
            return emojis[pairIndex]
        }
    }
    
    var cards: [MemorizeGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemorizeGame<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
}
