//
//  BlackjackViewModel.swift
//  Blackjack
//
//  Created by Benjamin Mecanovic on 18/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

enum DrawType {
    case initial
    case single
}

enum BlackjackParticipantType {
    case player
    case dealer
}

protocol BlackjackParticipant {
    var hand: [Card] { get }
    var aceValue: AceValue { get }
    func draw(type: DrawType)
    func fold()
    func getResult() -> Int
}

extension BlackjackParticipant {
    func draw(type: DrawType = .single) {
        return draw(type: type)
    }
}

protocol BlackjackViewModelDelegate: class {
    func didFinishDrawing(type: BlackjackParticipantType, cardName: String)
    func didChangeAceValue(aceValue: String)
    func didCardPositionChange(cardName: String)
    func didGameFinish(with alertMessage: String)
}

class BlackjackViewModel {
    
    
    // MARK: - Properties
    weak var delegate: BlackjackViewModelDelegate?
    private lazy var dealer: BlackjackParticipant = Dealer(delegate: self) // Self inaccessible until after init is called
    private lazy var player: BlackjackParticipant = Player(delegate: self)
    
    //MARK: Init
    init(delegate: BlackjackViewModelDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    func start() {
        player.fold()
        dealer.fold()
        Deck.shared.returnAndShuffle()
        dealer.draw(type: .initial)
        player.draw(type: .initial)
    }
    
    func hit() {
        player.draw()
    }
    
    func hold() {
        let playerResult = player.getResult()
        let dealerResult = dealer.getResult()
        print("Dealer: ", dealerResult)
        print("Player: ", playerResult)
        if playerResult > 21 {
            delegate?.didGameFinish(with: "Dealer wins!")
        } else if dealerResult > 21 {
            delegate?.didGameFinish(with: "Player wins!")
        } else {
            if playerResult > dealerResult {
                delegate?.didGameFinish(with: "Player wins!")
            } else if dealerResult > playerResult {
                delegate?.didGameFinish(with: "Dealer wins!")
            } else {
                delegate?.didGameFinish(with: "Tie!")
            }
        }
    }
    
    func changeAceValue() {
        (player as! Player).changeAceValue()
    }
}

extension BlackjackViewModel: PlayerDelegate, DealerDelegate {
    
    func didFinishDrawing(type: BlackjackParticipantType, cardName: String) {
        delegate?.didFinishDrawing(type: type, cardName: cardName)
    }
    
    
    func didChangeAceValue(aceValue: String) {
        delegate?.didChangeAceValue(aceValue: aceValue)
    }
    
    func didCardPositionChange(cardName: String) {
        delegate?.didCardPositionChange(cardName: cardName)
    }
    
}
