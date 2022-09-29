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
        Text(self.viewModel.game.name)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            viewModel: .init(
                game: .init(
                    name: "",
                    state: "",
                    board: [],
                    playerToken: "",
                    playerRole: "",
                    nextMoveToken: ""
                )
            )
        )
    }
}


