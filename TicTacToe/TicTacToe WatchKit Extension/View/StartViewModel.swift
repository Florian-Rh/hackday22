//
//  StartViewModel.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation

@MainActor internal class StartViewModel: ObservableObject {
    @Published internal private(set) var games: [GameListEntry] = []
    @Published internal private(set) var isLoading: Bool = false
    @Published internal var path: [Game] = []
    
    private let gameService = GameService()

    internal init() {
        self.loadGames()
    }

    internal func loadGames() {
        self.isLoading = true

        Task {
            do {
                self.games = try await self.gameService.loadGames()
            } catch let error {
                print(error)
            }
            self.isLoading = false
        }
    }

    internal func startNewGame() {
        Task {
            do {
                let game = try await self.gameService.startNewGame()
                path.append(game)
            } catch let error {
                print(error)
            }
        }
    }

    internal func joinGame(named name: String) {
        Task {
            do {
                let game = try await self.gameService.joinGame(named: name)
                path.append(game)
            } catch let error {
                print(error)
            }
        }
    }
}
