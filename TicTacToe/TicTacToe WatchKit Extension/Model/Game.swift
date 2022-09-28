//
//  Game.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation

internal struct Game: Codable {
    internal enum State: Codable {
        case awaitingJoin
        case yourTurn
        case theirTurn
        case youWon
        case theyWon
        case draw
    }

    internal enum Role: Codable {
        case X
        case O
    }

    internal let name: String
    internal let state: State
    internal let board: [String]
    internal let playerToken: String
    internal let playerRole: Role
    internal let nextMoveToken: String
    internal let createdAt: Date
    internal let updatedAt: Date
}
