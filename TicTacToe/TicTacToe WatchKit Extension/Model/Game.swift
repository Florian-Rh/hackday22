//
//  Game.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation

internal struct Game: Codable, Hashable {
    internal let name: String
    internal let state: String // TODO: deserialize to enum
    internal let board: [String]
    internal let playerToken: String
    internal let playerRole: String  // TODO: deserialize to enum
    internal let nextMoveToken: String?
    // internal let createdAt: Date // TODO: deserialize date
    // internal let createdAt: Date // TODO: deserialize date
}
