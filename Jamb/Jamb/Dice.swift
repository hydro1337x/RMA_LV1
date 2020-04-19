//
//  Dice.swift
//  Jamb
//
//  Created by Benjamin Mecanovic on 15/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import Foundation

class Dice {
    
    private(set) var result: Int
    private(set) var tag: Int
    var isLocked: Bool
    
    
    init(tag: Int) {
        result = Int.random(in: 1...6)
        self.tag = tag
        isLocked = false
    }
    
    final func roll() {
        result = Int.random(in: 1...6)
        print(result)
    }
}
