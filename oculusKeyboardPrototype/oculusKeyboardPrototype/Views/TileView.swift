//
//  TileView.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 25.10.2024.
//

import SwiftUI

struct TileView: View {
    let tile: Tile
    let tileSize: CGFloat
    let padding: CGFloat
    var onTap: (() -> Void)?

    var body: some View {
        let tilePosition = getTilePosition()
        
        let myCHar = String(Character(UnicodeScalar(tile.value > 0 ? tile.value : 100)!))

        
        RoundedRectangle(cornerRadius:padding)
                .fill(colorForTile(tile.position))
                .frame(width: tileSize*1, height: tileSize)
                    .overlay(
                        Text(myCHar)
                            .font(Font.system(size: 40))
                            .foregroundColor(isSelectTile(tile.position) ? .black : .white) // Adjust text color based on tile value

                    )
                    .position(tilePosition)
                    .animation(.easeInOut(duration: 0.2), value: tile.position) // Анимация перемещения плитки
                    .transition(.scale(scale: 0.12).combined(with:
                                .offset( x: tilePosition.x - 2 * tileSize,
                                         y: tilePosition.y - 2 * tileSize)))
                    .onTapGesture {
                        onTap?() // Execute the tap action if provided
                    }
                   
    }
    
    private func getTilePosition() -> CGPoint {
            let x = CGFloat(tile.position.col) * (tileSize + padding) + tileSize / 2
            let y = CGFloat(tile.position.row) * (tileSize + padding) + tileSize / 2

            return CGPoint(x: x, y: y)
        }
    
    private func colorForTile(_ value: Position) -> Color {
        if isSelectTile(value) {
            return Color(hex: "#F59563")
        } else {
            return Color(hex: "#EEE4DA")
        }
    }
    
    private func isSelectTile(_ value: Position) -> Bool {
        return (value.col > 0 && value.col < 5) && value.row == 1
    }
}

#Preview {
    
    TileView(
        tile: Tile(value: 90, position: Position(row: 0, col: 0)), tileSize: 90, padding: 8,
        onTap: {
            print("Tile tapped!")
        }
    )
        .padding()
}
