//
//  JambViewModel.swift
//  Jamb
//
//  Created by Benjamin Mecanovic on 15/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

protocol JambViewModelDelegate: class {
    func didChangeLockStatus(tag: Int, isLocked: Bool)
    func didFinishRollingWith(results: [Int: Int])
    func didGameStart()
    func didGameFinish()
    func didGameCounterChange(gameCounter: Int)
    func showAlert(for combination: String)
}

class JambViewModel {
    
    // MARK: - Properties
    private weak var delegate: JambViewModelDelegate?
    private var dice: [Dice] = []
    private var gameCounter = 0 {
        didSet {
            delegate?.didGameCounterChange(gameCounter: gameCounter)
            if gameCounter == 1 {
                print("Game started!")
                delegate?.didGameStart()
            } else if gameCounter == 3 {
                gameCounter = 0
                delegate?.didGameFinish()
                resetLockedDice()
                checkCombo()
                print("Game ended!")
            }
        }
    }
    
    
    // MARK: - Init
    init(delegate: JambViewModelDelegate) {
        self.delegate = delegate
        for tag in 1 ... 6 {
            dice.append(Dice(tag: tag))
        }
        checkCombo()
    }
    
    // MARK: - Methods
    final func rollDice() {
        for dice in dice where dice.isLocked == false {
            dice.roll()
        }
        let results = getDiceResults()
        delegate?.didFinishRollingWith(results: results)
        gameCounter += 1
    }
    
    final func changeLockStatusOnDice(with tag: Int) {
        for dice in dice where dice.tag == tag {
            dice.isLocked = !dice.isLocked
            delegate?.didChangeLockStatus(tag: tag, isLocked: dice.isLocked)
        }
    }
    
    private func getDiceResults() -> [Int: Int] {
        var results: [Int: Int] = [:]
        for dice in dice {
            results[dice.tag] = dice.result
        }
        return results
    }
    
    private func resetLockedDice() {
        for dice in dice where dice.isLocked == true {
            dice.isLocked = false
        }
    }
    
    private func checkCombo() {
        var diceResults: [Int] = []
        for dice in dice {
            diceResults.append(dice.result)
        }
        let isJambPoker = findJambPokerCombo(diceResults: diceResults)
        let isScale = findScaleCombo(diceResults: diceResults)
        if !isJambPoker && !isScale {
            delegate?.showAlert(for: "no combo :(")
        }
    }
    
    private func findJambPokerCombo(diceResults: [Int]) -> Bool {
        let mappedDiceResults = diceResults.map { ($0, 1) }
        let resultFrequencies = Dictionary(mappedDiceResults, uniquingKeysWith: +)
        for key in resultFrequencies.keys {
            if let freq = resultFrequencies[key] {
                if freq >= 5 {
                    delegate?.showAlert(for: "jamb")
                    return true
                } else if freq == 4 {
                    delegate?.showAlert(for: "poker")
                    return true
                }
            }
            
        }
        return false
    }
    
    private func findScaleCombo(diceResults: [Int]) -> Bool {
        var scaleCounter = 0
        let sortedDiceResults = diceResults.sorted()
        var lastResult = (sortedDiceResults.min() ?? 1) - 1
        sortedDiceResults.forEach { (result) in
            if result > lastResult && (result - lastResult) == 1 {
                scaleCounter += 1
                lastResult = result
            }
        }
        if scaleCounter >= 5 {
            delegate?.showAlert(for: "scale")
            return true
        }
        return false
    }
}
