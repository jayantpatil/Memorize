//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Jayant D Patil on 16/09/24.
//

import Foundation

struct MemorizeGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private var theme: Theme!
    private(set) var currentElements: [CardContent]
    private(set) var score = 0

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        currentElements = []
        startNewGame()
    }

    var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }

    mutating func startNewGame() {
        cards = []
        theme = Theme.allCases.randomElement()
        let currentElements: [CardContent] = Array(theme.emojis.shuffled().prefix(theme.numberOfPairs)) as! [CardContent]

        for pairIndex in 0..<max(2, theme.numberOfPairs) {

            let cardContent = currentElements[pairIndex] //cardContentFactory(pairIndex)
            cards.append(Card(content: cardContent, id: "\(pairIndex+1)a"))
            cards.append(Card(content: cardContent, id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
    }

    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                        cards[potentialMatchIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                        score += 2
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }

    func getName() -> String {
        theme.name
    }

    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = false
            didSet {
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched: Bool = false
        var hasBeenSeen: Bool = false
        let content: CardContent
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
