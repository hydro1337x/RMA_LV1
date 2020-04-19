//
//  Player.swift
//  Blackjack
//
//  Created by Benjamin Mecanovic on 18/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

protocol PlayerDelegate: class {
    func didChangeAceValue(aceValue: String)
    func didFinishDrawing(type: BlackjackParticipantType, cardName: String)
}

class Player: BlackjackParticipant {
    
    var hand: [Card]
    var aceValue: AceValue = .one
    private weak var delegate: PlayerDelegate?
    
    init(delegate: PlayerDelegate?) {
        self.hand = []
        self.delegate = delegate
    }
    
    final func changeAceValue() {
        if aceValue == .one {
            aceValue = .eleven
        } else {
            aceValue = .one
        }
        delegate?.didChangeAceValue(aceValue: "\(aceValue.rawValue)")
    }
    
    func draw(type: DrawType = .single) {
        switch type {
        case .initial:
            let cards = Deck.shared.getCardsFromTop(2)
            hand.append(contentsOf: cards)
            for card in cards {
                delegate?.didFinishDrawing(type: .player, cardName: card.imageName)
            }
        case .single:
            let card = Deck.shared.getCardsFromTop(1)
            hand.append(contentsOf: card)
            if let card = card.first {
                delegate?.didFinishDrawing(type: .player, cardName: card.imageName)
            }
        }
        
    }
    
    func fold() {
        hand.removeAll()
    }
    
    func getResult() -> Int {
        var result = 0
        for card in hand {
            result += card.evaluateCard(aceValue: aceValue)
        }
        return result
    }
}
