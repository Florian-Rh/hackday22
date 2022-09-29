//
//  Game.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation

internal struct Game: Codable, Hashable {
    internal enum State: String, Codable {
        case awaitingJoin = "awaiting_join"
        case yourTurn = "your_turn"
        case theirTurn = "their_turn"
        case youWon = "you_won"
        case theyWon = "they_won"
        case draw
    }

    internal enum Role: String, Codable {
        case playerX = "x"
        case playerO = "o"
    }

    internal enum BoardValue: String, Codable {
        case x
        case o
        case free = "f"
    }

    internal let name: String
    internal let state: State
    internal let board: [BoardValue]
    internal let playerToken: String
    internal let playerRole: Role
    internal let nextMoveToken: String?
}
