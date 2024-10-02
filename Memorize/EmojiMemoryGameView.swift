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
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundColor(.orange)
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

struct CardView: View {
    var card: MemorizeGame<String>.Card
    init(_ card: MemorizeGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }.opacity(card.isMatched ? 0 : 1)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
