//
//  ViewController.swift
//  Blackjack
//
//  Created by Benjamin Mecanovic on 18/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

class BlackjackViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var dealerStackView: UIStackView!
    @IBOutlet private weak var playerStackView: UIStackView!
    @IBOutlet private weak var hitButton: UIButton!
    @IBOutlet private weak var holdButton: UIButton!
    @IBOutlet private weak var changeButton: UIButton!
    @IBOutlet private weak var aceValueLabel: UILabel!
    @IBOutlet weak var playerStackViewBg: UIView!
    @IBOutlet weak var dealerStackViewBg: UIView!
    @IBOutlet weak var aceValueBackgroundView: UIView!
    
    // MARK: - Properties
    private var viewModel: BlackjackViewModel!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BlackjackViewModel(delegate: self)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlert(with: "Start game?", message: "", buttonTitle: "START") { [weak self] (_) in
            self?.viewModel.start()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        
        playerStackViewBg.backgroundColor = .systemGreen
        playerStackViewBg.layer.cornerRadius = 10
        playerStackViewBg.layer.masksToBounds = true
        
        dealerStackViewBg.backgroundColor = .systemGreen
        dealerStackViewBg.layer.cornerRadius = 10
        dealerStackViewBg.layer.masksToBounds = true
        
        aceValueBackgroundView.layer.cornerRadius = 10
        aceValueBackgroundView.layer.masksToBounds = true
        
        changeButton.layer.cornerRadius = 10
        changeButton.layer.masksToBounds = true
        
        hitButton.layer.cornerRadius = 10
        hitButton.layer.masksToBounds = true
        
        holdButton.layer.cornerRadius = 10
        holdButton.layer.masksToBounds = true
        
        
    }
    
    // MARK: - Actions
    @IBAction private func hitButtonPressed(_ sender: UIButton) {
        viewModel.hit()
    }
    
    @IBAction private func holdButtonPressed(_ sender: UIButton) {
        viewModel.hold()
    }
    
    @IBAction private func changeButtonPressed(_ sender: UIButton) {
        viewModel.changeAceValue()
    }
    
    // MARK: - Methods
 
    private func resetUI() {
        for subview in dealerStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        for subview in playerStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    private func presentAlert(with title: String,
                              message: String,
                              buttonTitle: String,
                              actionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: actionHandler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension BlackjackViewController: BlackjackViewModelDelegate {

    func didFinishDrawing(type: BlackjackParticipantType, cardName: String) {
        let image = UIImage(named: cardName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        if type == .player {
            playerStackView.addArrangedSubview(imageView)
        } else {
            dealerStackView.addArrangedSubview(imageView)
        }
    }
    
    func didChangeAceValue(aceValue: String) {
        aceValueLabel.text = aceValue
    }
    
    func didCardPositionChange(cardName: String) {
        (dealerStackView.arrangedSubviews.first as! UIImageView).image = UIImage(named: cardName)
    }
    
    func didGameFinish(with alertMessage: String) {
        presentAlert(with: "GAME OVER!", message: alertMessage, buttonTitle: "RESTART") { [weak self] (_) in
            self?.resetUI()
            self?.viewModel.start()
        }
    }
}

