//
//  GameListEntry.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation

internal class GameListEntry: Codable, Identifiable {
    internal let name: String
    // internal let createdAt: Date // TODO: deserialize Date
}
