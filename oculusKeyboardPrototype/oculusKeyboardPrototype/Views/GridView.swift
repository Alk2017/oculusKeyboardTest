//
//  GridView.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 25.10.2024.
//

import SwiftUI

var width = 6
let height = 3

//Define the GridView to use TileView
struct GridView: View {
    let tiles: [[Tile]]
    let tileSize: CGFloat
    let padding: CGFloat
    @Binding var text: String
    
    
    var body: some View {
        ZStack {
            // Background grid
            BackgroundView(tileSize: tileSize, padding: padding)
            // Foreground non-zero tiles
            ForEach(tiles.flatMap { $0 }) { tile in
                TileView(tile: tile, tileSize: tileSize, padding: padding,onTap: {
                    if (isSelectTile(tile.position)) {
                        let myCHar = String(Character(UnicodeScalar(tile.value > 0 ? tile.value : 100)!))
                        switch myCHar {
                        case "?":
                            if !text.isEmpty {
                                text.removeLast()
                            }
                        default:
                            text.append(myCHar)
                        }
                    }
                })
            }
            .padding()
        }
        .frame(width: CGFloat(width) * tileSize + 3 * padding, height: CGFloat(height) * tileSize + 3 * padding) // Adjust frame size
    }
    
    private func isSelectTile(_ value: Position) -> Bool {
        return (value.col > 0 && value.col < 5) && value.row == 1
    }
}

struct BackgroundView: View {
    
    let tileSize: CGFloat
    let padding: CGFloat
    
    var body: some View {
        // Background grid
        VStack(spacing: padding) {
            ForEach(0..<height) { row in
                HStack(spacing: padding) {
                    ForEach(0..<width) { col in
                        RoundedRectangle(cornerRadius:padding)
                            .fill(Color.colorEmpty)
                            .frame(width: tileSize, height: tileSize)
                    }
                }
            }
        }
        .padding()
        .background(Color.colorBG)
    }
}

#Preview {
    @Previewable @State var text2: String = ""
    var value = 60
    let tiles = (0..<height).map { row in
            (0..<width).map { col in
                value += 1
                return Tile(value: value, position: Position(row: row, col: col))
            }
        }
    
    GridView(tiles:  tiles, tileSize: 100, padding: 2, text: $text2)
}
