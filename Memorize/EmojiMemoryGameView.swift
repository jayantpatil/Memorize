//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Jayant D Patil on 14/09/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemorizeGame<String>.Card

    @ObservedObject var viewModel: EmojiMemoryGame
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    private let deckWidth: CGFloat = 50

    var body: some View {
        VStack {
            cards.foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
                Spacer()
                newGame
            }
            .font(.largeTitle)
        }
        .padding()
    }

    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }

    private var newGame: some View {
        Button("New Game") {
            withAnimation {
                viewModel.startNewGame()
            }
        }
    }

    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
        .foregroundColor(viewModel.color)
    }
    @State private var dealt = Set<Card.ID>()
    @State private var lastScoreChange = (0, causedByCardId: "")
    @Namespace private var dealingNamespace

    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }

    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }

    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / cardAspectRatio)
        .onTapGesture {
            deal()
        }
    }

    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }

    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }

    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

enum Theme: String, CaseIterable, Identifiable {
    case Vehicle
    case Animal
    case Food

    var id: Self { self }
    var name: String {
        switch self {
        case .Vehicle:
            "Vehicle"

        case .Animal:
            "Animal"

        case .Food:
            "Food"
        }
    }

    var symbol: String {
        switch self {
        case .Vehicle:
            "car"
        case .Animal:
            "hare"
        case .Food:
            "fork.knife.circle"
        }
    }

    var color: Color {
        switch self {
        case .Vehicle:
            return .gray

        case .Animal:
            return .red

        case .Food:
            return .green
        }
    }

    var numberOfPairs: Int {
        switch self {
        case .Vehicle:
            return 8
        case .Animal:
            return 10
        case .Food:
            return 7
        }
    }

    var emojis: [String] {
        switch self {
        case .Vehicle:
            return ["🏎️", "🚓", "✈️", "🚀", "🚗", "🚌", "🛶", "🛸"]

        case .Animal:
            return ["🦖", "🐳", "🦍" , "🐇", "🐶", "🦁", "🐒", "🦄", "🐙", "🦋"]

        case .Food:
            return  ["🍉" , "🍕", "🍫", "🍩", "🥞", "🍒", "🍍", "🍔", "🥗", "🍇", "🌮", "🥟"]
        }
    }

}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
