//
//  GameViewModel.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation

@MainActor internal class GameViewModel: ObservableObject {
    private let gameService = GameService()
    internal let game: Game

    internal init(game: Game) {
        self.game = game
    }
}
