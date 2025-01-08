//
//  GameView.swift
//  Game2048ChatGPT
//
//  Created by Tatiana Kornilova on 21.08.2024.
//

import SwiftUI

struct GameView: View {
    @State private var viewModel = GameViewModel()
    @State private var text: String = ""
    let tileSize: CGFloat = 100
    let padding: CGFloat = 6
    @State var timer = Timer.publish(every: 0.45, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            TextField("Enter text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            //  Grid
            GridView(tiles: viewModel.tiles, tileSize: tileSize, padding: padding, text: $text)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                          withAnimation {
                                handleSwipe(value: value)
                          }
                        }
                )
        
        }
    }
    
    // Handle swipe gesture and trigger game actions
    private func handleSwipe(value: DragGesture.Value) {
        let threshold: CGFloat = 20
        let horizontalShift = value.translation.width
        let verticalShift = value.translation.height
        
            if abs(horizontalShift) > abs(verticalShift) {
                if horizontalShift > threshold {
                    viewModel.move(.right)
                } else if horizontalShift < -threshold {
                    viewModel.move(.left)
                }
            } else {
                if verticalShift > threshold {
                    viewModel.move(.down)
                } else if verticalShift < -threshold {
                    viewModel.move(.up)
                }
           }
    }
}

#Preview {
    GameView() //.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
