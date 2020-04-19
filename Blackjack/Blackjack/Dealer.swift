//
//  Dealer.swift
//  Blackjack
//
//  Created by Benjamin Mecanovic on 18/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

protocol DealerDelegate: class {
    func didFinishDrawing(type: BlackjackParticipantType, cardName: String)
    func didCardPositionChange(cardName: String)
}

class Dealer: BlackjackParticipant {
    
    var hand: [Card]
    var aceValue: AceValue = .eleven
    private weak var delegate: DealerDelegate?
    private var result = 0 {
        didSet {
            if result <= 16 {
                draw()
                calculateResult()
            }
        }
    }
    
    init(delegate: DealerDelegate?) {
        self.hand = []
        self.delegate = delegate
    }
    
    func draw(type: DrawType = .single) {
        switch type {
        case .initial:
            let cards = Deck.shared.getCardsFromTop(2)
            if let card = cards.first {
                card.makeFaceDown()
            }
            hand.append(contentsOf: cards)
            for card in cards {
                delegate?.didFinishDrawing(type: .dealer, cardName: card.imageName)
            }
        case .single:
            let card = Deck.shared.getCardsFromTop(1)
            hand.append(contentsOf: card)
            if let card = card.first {
                delegate?.didFinishDrawing(type: .dealer, cardName: card.imageName)
            }
        }
    }
    
    func fold() {
        hand.removeAll()
    }
    
    private func calculateResult() {
        var r = 0
        for card in hand {
            r += card.evaluateCard(aceValue: aceValue)
        }
        if r > 21 {
            aceValue = .one
        }
        result = r
    }
    
    private func makeCardsFaceUp() {
        for card in hand {
            card.makeFaceUp()
        }
        if let card = hand.first {
            delegate?.didCardPositionChange(cardName: card.imageName)
        }
    }
    
    func getResult() -> Int {
        calculateResult()
        makeCardsFaceUp()
        return result
    }
}
