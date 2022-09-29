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
            Text(self.viewModel.title)
            Text(self.viewModel.playerTag)
                .padding(.bottom, 2.0)

            Text(self.viewModel.formattedGameState)
                .multilineTextAlignment(.center)
                .fontWeight(self.viewModel.formattedGameStateFontWeight)
                .foregroundColor(self.viewModel.formattedGameStateFontColor)

            Grid(alignment: .center, horizontalSpacing: 1.0, verticalSpacing: 1.0) {
                ForEach(0...2, id: \.self) { row in
                    GridRow {
                        ForEach(0...2, id: \.self) { column in
                            let buttonIndex = column + row*3
                            Button(self.viewModel.formattedBoardValues[buttonIndex]) {
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
                    state: .yourTurn,
                    board: [
                        .o, .x, .free,
                        .x, .o, .free,
                        .x, .o, .free,
                    ],
                    playerToken: "playerToken",
                    playerRole: .playerX,
                    nextMoveToken: "nextMoveToken"
                )
            )
        )
    }
}


