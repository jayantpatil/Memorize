//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Jayant D Patil on 16/09/24.
//

import Foundation

struct MemorizeGame<CardContent> {
    var cards: [Card]
    
    func choose(card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var cardContent: CardContent
    }
}
