//
//  GameViewModel.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Combine
import Foundation
import SwiftUI

@MainActor internal class GameViewModel: ObservableObject {
    @Published internal private(set) var title: AttributedString = ""
    @Published internal private(set) var playerTag: AttributedString = ""
    @Published internal private(set) var formattedBoardValues: [String] = .init(repeating: "", count: 9)
    @Published internal private(set) var formattedGameState: String = ""
    @Published internal private(set) var formattedGameStateFontWeight: Font.Weight = .medium
    @Published internal private(set) var formattedGameStateFontColor: Color = .accentColor
    @Published internal private(set) var isGameOver: Bool = false

    private let gameService = GameService()
    private let playerToken: String
    private var timer: Timer? = nil
    private var subscribers = Set<AnyCancellable>()
    @Published private var game: Game

    internal init(game: Game) {
        self.game = game
        self.playerToken = game.playerToken

        self.$game
            .sink { [unowned self] newGame in
                self.title = try! AttributedString(markdown: "Game: _\(newGame.name)_")
                self.playerTag = try! AttributedString(markdown: "You are player **\(newGame.playerRole.rawValue.uppercased())**")
                self.formattedBoardValues = newGame.board.map { $0 == .free ? "" : $0.rawValue.uppercased() }
                self.formattedGameState = newGame.state.formattedState
                self.isGameOver = newGame.state.isGameOver
                self.formattedGameStateFontWeight = self.isGameOver ? .heavy : .medium
                self.formattedGameStateFontColor = newGame.state.associatedColor
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
                fatalError("Cannot make a move without a next move token")
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
        self.game.state == .yourTurn
        && self.game.board[index] == .free
        && self.game.nextMoveToken?.isEmpty == false
    }

    @objc
    private func updateGame() {
        Task {
            do {
                self.game = try await self.gameService.loadGame(forPlayerToken: self.playerToken)
            } catch let error {
                print("An error occured while updating the game: \(error)")
            }
        }
    }
}

extension Game.State {
    fileprivate var formattedState: String {
        switch self {
            case .awaitingJoin:
                return "Waiting for opponent to join"
            case .yourTurn:
                return "Your turn!"
            case .theirTurn:
                return "Opponent's turn"
            case .youWon:
                return "Congratulations, you won!"
            case .theyWon:
                return "You lost!"
            case .draw:
                return "Looks like a draw"
        }
    }

    fileprivate var isGameOver: Bool {
        switch self {
            case .awaitingJoin, .yourTurn, .theirTurn:
                return false
            case .youWon, .theyWon, .draw:
                return true
        }
    }

    fileprivate var associatedColor: Color {
        switch self {
            case .youWon:
                return .green
            case .theyWon:
                return .red
            default:
                return .accentColor
        }
    }
}
