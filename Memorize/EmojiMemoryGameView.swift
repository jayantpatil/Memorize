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
    var body: some View {
        VStack {
            cards
                .foregroundColor(viewModel.color)
            HStack {
                score
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
            CardView(card)
                .padding(spacing)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
        }
        .foregroundColor(viewModel.color)
    }

    private func scoreChange(causedBy card: Card) -> Int {
        return 0
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
