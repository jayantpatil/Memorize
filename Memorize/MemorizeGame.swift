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
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
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

    struct Card: Equatable, Identifiable, CustomStringConvertible {
        
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }

                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen: Bool = false
        let content: CardContent
        var id: String
        var description: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? " matched" : "")"
        }

        // MARK: - Bonus Time

        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }

        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }

        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }

        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6

        // the last time this card was turned face up
        var lastFaceUpDate: Date?

        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
