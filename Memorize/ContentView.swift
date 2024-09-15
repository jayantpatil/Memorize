//
//  ContentView.swift
//  Memorize
//
//  Created by Jayant D Patil on 14/09/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTheme: Theme = Theme.allCases.first!
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                cards
            }
            themeChooser
        }
        .padding()
    }
    
    var themeChooser: some View {
        HStack(spacing: 50) {
            ForEach(Theme.allCases, id: \.id) { theme in
                Button(action: {
                    selectedTheme = theme
                }, label: {
                    VStack {
                        let systemName = theme == selectedTheme ? theme.symbol + ".fill" : theme.symbol
                        Image(systemName: systemName)
                            .font(.title)
                        Text(theme.rawValue)
                            .font(.footnote)
                    }
                })
            }
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
            let indicesList = [selectedTheme.emojis.indices, selectedTheme.emojis.indices].flatMap { $0 }.shuffled()
            ForEach(Array(indicesList.enumerated()), id: \.offset) { index, number in
                CardView(content: selectedTheme.emojis[number])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(selectedTheme.color)
    }
}

enum Theme: String, CaseIterable, Identifiable {
    case Vehicle
    case Animal
    case Food
    
    var id: Self { self }
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
    var emojis: [String] {
        switch self {
        case .Vehicle:
            return ["🏎️", "🚓", "✈️", "🚀", "🚗", "🚌", "🛶", "🛸"]
            
        case .Animal:
            return ["🦖", "🐳", "🦍" , "🐇", "🐶", "🦁", "🐒", "🦄", "🐙"]

        case .Food:
            return  ["🍉" , "🍕", "🍫", "🍩", "🥞", "🍒", "🍍", "🍔", "🥗", "🍇"]
        }
    }
    
}

struct CardView: View {
    let content: String
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
