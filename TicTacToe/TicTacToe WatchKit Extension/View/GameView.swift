//
//  GameView.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import SwiftUI

struct GameView: View {
    @StateObject internal var viewModel: GameViewModel

    var body: some View {
        ScrollView {
            Text(self.viewModel.name)
            Text(self.viewModel.gameState)
            Grid(alignment: .center, horizontalSpacing: 1.0, verticalSpacing: 1.0) {
                ForEach(0...2, id: \.self) { row in
                    GridRow {
                        ForEach(0...2, id: \.self) { column in
                            let buttonIndex = column + row*3
                            Button(self.viewModel.boardValues[buttonIndex]) {
                                self.viewModel.makeMove(atIndex: buttonIndex)
                            }
                            .disabled(!self.viewModel.isButtonEnabled(forIndex: buttonIndex))
                        }
                    }
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            viewModel: .init(
                game: .init(
                    name: "Game name",
                    state: "your_turn",
                    board: [
                        "f", "f", "f",
                        "f", "f", "f",
                        "f", "f", "f",
                    ],
                    playerToken: "playerToken",
                    playerRole: "X",
                    nextMoveToken: "nextMoveToken"
                )
            )
        )
    }
}


