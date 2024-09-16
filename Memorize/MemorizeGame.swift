//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Jayant D Patil on 16/09/24.
//

import Foundation

struct MemorizeGame<CardContent> {
   private(set) var cards: [Card]
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let cardContent = cardContentFactory(pairIndex)
            cards.append(Card(cardContent: cardContent))
            cards.append(Card(cardContent: cardContent))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        let cardContent: CardContent
    }
}
