//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jayant D Patil on 16/09/24.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemorizeGame<String>.Card

    private static let emojis = ["🏎️", "🚓", "✈️", "🚀", "🚗", "🚌", "🛶", "🛸"]
    
    @Published private var model = createMemorizeGame()

    private static func createMemorizeGame() -> MemorizeGame<String> {
        MemorizeGame(numberOfPairsOfCards: 2) { pairIndex in
            guard emojis.indices.contains(pairIndex) else {
                return "⁉️"
            }
            return emojis[pairIndex]
        }
    }

    var cards: [Card] {
        model.cards
    }

    var color: Color {
        .orange
    }

    var score: Int {
        model.score
    }

    func getName() -> String {
        model.getName()
    }

    // MARK: - Intents

    func choose(_ card: Card) {
        model.choose(card)
    }

    func startNewGame() {
        model.startNewGame()
    }
    //    func shuffle() {
    //        model.shuffle()
    //    }
}
