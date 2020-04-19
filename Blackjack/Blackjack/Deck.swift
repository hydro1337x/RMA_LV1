//
//  Deck.swift
//  Blackjack
//
//  Created by Benjamin Mecanovic on 18/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

enum Value: String, CaseIterable {
    case two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", ten = "10",
         jack = "J", queen = "Q", king = "K", ace = "A"
}

enum Suit: String, CaseIterable {
    case diamond = "D", clubs = "C", hearts = "H", spades = "S"
}

enum AceValue: Int {
    case one = 1
    case eleven = 11
}

class Card {
    
    private(set) var suit: Suit
    private(set) var value: Value
    private(set) var imageName: String
    
    init(value: Value, suit: Suit) {
        self.value = value
        self.suit = suit
        imageName = value.rawValue + suit.rawValue
    }
    
    final func makeFaceDown() {
        if imageName != "red_back" {
            imageName = "red_back"
        }
    }
    
    final func makeFaceUp() {
        imageName = value.rawValue + suit.rawValue
    }
    
    final func evaluateCard(aceValue: AceValue) -> Int {
        switch self.value {
            case .two:
                return 2
            case .three:
                return 3
            case .four:
                return 4
            case .five:
                return 5
            case .six:
                return 6
            case .seven:
                return 7
            case .eight:
                return 8
            case .nine:
                return 9
            case .ten, .jack, .queen, .king:
                return 10
            case .ace:
                return aceValue.rawValue
        }
    }
    
}

class Deck {
    
    static let shared = Deck()
    final var cards: [Card]
    
    init() {
        cards = []
        createDeck()
        cards.shuffle()
    }
    
    final func returnAndShuffle() {
        createDeck()
        cards.shuffle()
    }
    
    final func getCardsFromTop(_ amount: Int) -> [Card] {
        let cardsToReturn = Array(cards.prefix(amount))
        cards.removeFirst(amount)
        return cardsToReturn
    }
    
    private func createDeck() {
        cards.removeAll()
        for suit in Suit.allCases {
            for value in Value.allCases {
                cards.append(Card(value: value, suit: suit))
            }
        }
    }
}
