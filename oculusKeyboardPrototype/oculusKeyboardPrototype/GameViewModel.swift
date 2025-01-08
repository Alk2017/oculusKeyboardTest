//
//  GameViewModel.swift
//  Game2048ChatGPT Test
//
//  Created by Tatiana Kornilova on 21.08.2024.
//

import SwiftUI

@Observable
class GameViewModel /*: ObservableObject */ {
   /*@Published */private var game: Game
    var isShowingOptimalDirection = false
    
    init() {
        self.game = Game()
    }
    
    var tiles: [[Tile]] {
        game.tiles
    }
   
    var optimalDirection: Direction {
        Direction.up
    }
  
    // MARK: Intents
    
    func resetGame() {
        game.resetGame()
    }
    
    func move(_ direction: Direction) {
        game.move(direction)
    }
        
    
    // Other methods that interact with `Game` struct
}
