//
//  Game.swift
//  Game2048ChatGPT Test
//
//  Created by Tatiana Kornilova on 29.08.2024.
//

//import SwiftUI
import Foundation

struct Game {
    var tiles: [[Tile]] = []
    var keyBoard: [[String]] = [
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"],
        ["#", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "#"],
        ["#", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "#"],
        ["#", "A", "S", "D", "F", "G", "H", "J", "K", "L", "/", "#"],
        ["#", "Z", "X", "C", "V", "B", "N", "M", "<", ">", "?", "#"],
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"]
    ]
    var width = 6
    var height = 3

    init() {
        resetGame()
    }
    
    mutating func resetGame() {
        var value = 0
        tiles = (0..<height).map { row in
                (0..<width).map { col in
                    value += 1
                    return Tile(value: Int(UnicodeScalar(keyBoard[row][col])!.value), position: Position(row: row, col: col))
                }
            }
    }
   
    init(matrix: [[Tile]]) {
        self.tiles = matrix
    }

    private mutating func rotateLeft() {
        rotateRight()
        rotateRight()
        rotateRight()
     }

    private mutating func rotateRight() {
        tiles = (0..<width).map { col in
            (0..<height).reversed().map { row in
//                 print(String(format: "[%d:%d]", col, row))
                var tile = tiles[row][col]
                tile.position = Position(row: col, col:  (height-1) - row)
                 return tile
             }
         }
        height = tiles.count
        width = tiles[0].count
        keyBoard = (0..<keyBoard[0].count).map { col in
            (0..<keyBoard.count).reversed().map { row in
                return keyBoard[row][col]
             }
         }
     }
    
    mutating func rotateRightTwice() {
        rotateRight()
        rotateRight()
    }
    
    private func slideRow(_ row: [Tile]) -> [Tile] {
        var canMove = true
        let lastChar = String(Character(UnicodeScalar(row.last!.value)!))
        var newChar = ""
        for keyRow in keyBoard {
            if keyRow.contains(lastChar) {
                if (lastChar == keyRow.last!) {
                    canMove = false
                    break
                } else {
                    newChar = keyRow[keyRow.firstIndex(of: lastChar)! + 1]
                    break
                }
            }
            
        }
        
        if canMove {
            var newRow: [Tile] = row.enumerated().map { (index, tile) in
                var updatedTile = tile
                updatedTile.position = Position(row: tile.position.row, col: tile.position.col-1)
                return updatedTile
            }
            newRow.removeFirst()
            
            
            
            // Add zeros to the end of the row with updated positions
            let zeros = (newRow.count..<row.count).map { colIndex in
                Tile(value: Int(Character(newChar).asciiValue ?? 0), position: Position(row: row.first?.position.row ?? 0, col: colIndex))
            }

            return newRow + zeros
        } else {
            return row
        }
        
    }
    
    
    //------------------- SLIDE ---------------
    mutating func slide(_ direction: Direction) -> Bool {
        var moved = false

        // Rotate the board so we can always handle the move as a "left" move
        switch direction {
        case .up:
            rotateLeft()
        case .down:
            rotateRight()
        case .right:
           rotateRightTwice()
        case .left:
            break
        }

        for i in 0..<height {
            let row = tiles[i]
           
            let newRow = slideRow(row)
            if newRow != row {
                moved = true
                    tiles[i] = newRow
            }
        }

        switch direction {
        case .up:
            rotateRight()
        case .down:
            rotateLeft()
        case .right:
             rotateRightTwice()
        case .left:
            break
        }
        return moved
    }
    
    mutating func move(_ direction: Direction) {
        let moved = slide(direction)
        
        if moved {
            print("moved")
//            printBoard()
        }

    }

    func printBoard() {
        print("===Board===")
        for row in 0..<tiles.count{
            printRow(row: tiles[row])
        }
        print("====End====")
    }
    
    func printRow(row: [Tile]) {
        let newRow:[String] = row.map{ String($0.value) + "(" + String($0.position.row) + ":" + String($0.position.col) + ")" }
        print(newRow)
    }
}
