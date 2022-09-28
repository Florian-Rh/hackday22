//
//  GameService.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation


internal class GameService {
    internal func startNewGame() {

    }

    internal func joinGame(named name: String) {

    }

    internal func loadGames() -> [String] {
        []
    }

    internal func makeMove(nextMoveToken: String, fieldIndex: Int) {

    }
}

extension JSONEncoder {
    fileprivate static var snakeCaseEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }
}

extension JSONDecoder {
    fileprivate static var snakeCaseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }
}
