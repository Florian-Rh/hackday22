//
//  GameViewModel.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Combine
import Foundation

@MainActor internal class GameViewModel: ObservableObject {
    private let gameService = GameService()
    private let playerToken: String
    private var subscribers = Set<AnyCancellable>()

    @Published private var game: Game
    @Published internal private(set) var name: String = "unknown"
    @Published internal private(set) var boardValues: [String] = .init(repeating: "", count: 9)
    @Published internal private(set) var gameState: String = ""

    internal init(game: Game) {
        self.game = game
        self.playerToken = game.playerToken

        self.$game
            .sink { [unowned self] newGame in
                self.name = newGame.name
                self.boardValues = newGame.board.map { $0.lowercased() == "f" ? "" : $0.uppercased() }
                self.gameState = newGame.state
            }
            .store(in: &self.subscribers)

        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateGame), userInfo: nil, repeats: true)
    }

    internal func makeMove(atIndex index: Int) {
        Task {
            guard let nextMoveToken = self.game.nextMoveToken else {
                fatalError("cannot make a move without a next move token")
            }
            do {
                self.game = try await self.gameService
                    .makeMove(
                        playerToken: self.playerToken,
                        nextMove: .init(nextMoveToken: nextMoveToken, field: index)
                    )
            }
        }
    }

    internal func isButtonEnabled(forIndex index: Int) -> Bool {
        self.gameState == "your_turn" && self.boardValues[index].isEmpty
    }

    @objc
    private func updateGame() {
        Task {
            if let game = try? await self.gameService.loadGame(forPlayerToken: self.playerToken) {
                self.game = game
            }
        }
    }
}
