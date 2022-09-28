//
//  Move.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation


internal struct Move: Codable {
    internal let nextMoveToken: String
    internal let field: Int
}
