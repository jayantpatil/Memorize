//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Jayant D Patil on 14/09/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    var body: some View {
        VStack {
            cards
                .animation(.default, value: viewModel.cards)
            Button("New Game") {
                viewModel.startNewGame()
            }
        }
        .padding()
    }

    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            CardView(card)
                .padding(spacing)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundColor(viewModel.color)
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
