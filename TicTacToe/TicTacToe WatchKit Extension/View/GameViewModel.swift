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
    private var timer: Timer? = nil

    @Published private var game: Game
    @Published internal private(set) var name: String = "unknown"
    @Published internal private(set) var boardValues: [String] = .init(repeating: "", count: 9)
    @Published internal private(set) var gameState: String = "" // TODO: should be formatted
    @Published internal private(set) var isGameOver: Bool = false // TODO: should be set from the game state

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

        // Poll for game updates every two seconds
        self.timer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(self.updateGame),
            userInfo: nil,
            repeats: true
        )
    }

    deinit {
        self.timer?.invalidate()
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
            } catch let error {
                print("An error occured while making a move: \(error)")
            }
        }
    }

    /// A button is enabled when all of the following are true:
    /// a) it is the current player's turn
    /// b) the designated field is free
    /// c) the game has a token for the next move
    internal func isButtonEnabled(forIndex index: Int) -> Bool {
        self.game.state == "your_turn"
        && self.game.board[index].lowercased() == "f"
        && self.game.nextMoveToken?.isEmpty == false
    }

    @objc
    private func updateGame() {
        Task {
            // use optional unwrap to ignore failed updates
            if let game = try? await self.gameService.loadGame(forPlayerToken: self.playerToken) {
                self.game = game
            }
        }
    }
}
