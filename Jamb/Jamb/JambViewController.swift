//
//  ViewController.swift
//  Jamb
//
//  Created by Benjamin Mecanovic on 15/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

class JambViewController: UIViewController, JambViewModelDelegate {
    
    // MARK: - Outlets
    @IBOutlet var diceButtons: [UIButton]!
    @IBOutlet weak var gameCounterLabel: UILabel!
    @IBOutlet weak var rollButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: JambViewModel!
    private let imageNames = ["one", "two", "three", "four", "five", "six"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = JambViewModel(delegate: self)
        setupUI()
        
    }
    
    func setupUI() {
        view.backgroundColor = .black
        for diceButton in diceButtons {
            let image = UIImage(named: imageNames[diceButton.tag - 1])?.withRenderingMode(.alwaysTemplate)
            diceButton.setImage(image, for: .normal)
            diceButton.tintColor = .white
        }
        rollButton.layer.cornerRadius = 20
        changeDiceButtonsUserInteraction(to: false)
    }

    // MARK: - Actions
    
    @IBAction private func roll(_ sender: UIButton) {
        viewModel.rollDice()
        print("===================")
    }
    
    @IBAction func diceButtonTapped(_ sender: UIButton) {
        viewModel.changeLockStatusOnDice(with: sender.tag)
    }
    
    
    // MARK: - Methods
    private func changeDiceButtonsUserInteraction(to isEnabled: Bool) {
        for diceButton in diceButtons {
            diceButton.isUserInteractionEnabled = isEnabled
        }
    }
    
    private func resetUI() {
        for diceButton in diceButtons {
            diceButton.tintColor = .white
        }
    }
    
    //MARK: - JambViewModelDelegate
    func didChangeLockStatus(tag: Int, isLocked: Bool) {
        for diceButton in diceButtons where diceButton.tag == tag {
            if isLocked {
                diceButton.tintColor = .red
            } else {
                diceButton.tintColor = .white
            }
        }
    }
    
    /// Key: dice tag, Value: dice result
    func didFinishRollingWith(results: [Int: Int]) {
        for tag in results.keys {
            if let result = results[tag] {
                let diceButton = diceButtons.first { $0.tag == tag }
                let diceNumberImage = UIImage(named: imageNames[result - 1])?.withRenderingMode(.alwaysTemplate)
                diceButton?.setImage(diceNumberImage, for: .normal)
            }
        }
    }
    
    func didGameStart() {
        changeDiceButtonsUserInteraction(to: true)
    }
    
    func didGameFinish() {
        resetUI()
        changeDiceButtonsUserInteraction(to: false)
    }
    
    func didGameCounterChange(gameCounter: Int) {
        gameCounterLabel.text = "\(gameCounter)"
    }
    
    func showAlert(for combination: String) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "COMBO", message: combination.uppercased(), preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

