//
//  GameService.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import Foundation


internal class GameService {
    private static var host: String = "https://tik-tak-tioki.fly.dev"

    private static func getURLRequest(
        forEndpoint endpoint: String,
        withHttpMethod httpMethod: String,
        withQueryItems queryItems: [URLQueryItem] = []
    ) -> URLRequest {
        var urlComponents = URLComponents(string: "\(Self.host)/api/\(endpoint)")!
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = httpMethod

        return urlRequest
    }

    internal func startNewGame() async throws -> Game {
        var urlRequest = Self.getURLRequest(forEndpoint: "game", withHttpMethod: "POST")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let game = try JSONDecoder.snakeCaseDecoder.decode(Game.self, from: data)

        return game
    }

    internal func loadGames() async throws -> [GameListEntry] {
        let urlRequest = Self.getURLRequest(forEndpoint: "join", withHttpMethod: "GET")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let games = try JSONDecoder.snakeCaseDecoder.decode([GameListEntry].self, from: data)

        return games
    }

    internal func joinGame(named name: String) async throws -> Game {
        var urlRequest = Self.getURLRequest(forEndpoint: "join", withHttpMethod: "POST")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let joinRequest = JoinRequest(name: name)
        urlRequest.httpBody = try JSONEncoder.snakeCaseEncoder.encode(joinRequest)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let game = try JSONDecoder.snakeCaseDecoder.decode(Game.self, from: data)

        return game
    }

    internal func loadGame(forPlayerToken playerToken: String) async throws -> Game {
        let urlRequest = Self.getURLRequest(
            forEndpoint: "game",
            withHttpMethod: "GET",
            withQueryItems: [
                .init(name: "player_token", value: playerToken)
            ]
        )
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let game = try JSONDecoder.snakeCaseDecoder.decode(Game.self, from: data)

        return game
    }

    internal func makeMove(playerToken: String, nextMove: Move) async throws -> Game {
        var urlRequest = Self.getURLRequest(
            forEndpoint: "move",
            withHttpMethod: "POST",
            withQueryItems: [
                .init(name: "player_token", value: playerToken)
            ]
        )
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder.snakeCaseEncoder.encode(nextMove)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let game = try JSONDecoder.snakeCaseDecoder.decode(Game.self, from: data)

        return game
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
