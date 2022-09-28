//
//  StartView.swift
//  TicTacToe WatchKit Extension
//
//  Created by Florian Rhein on 28.09.22.
//

import SwiftUI

struct StartView: View {
    @StateObject private var viewModel = StartViewModel()

    var body: some View {
        NavigationStack(path: self.$viewModel.path) {
            VStack {
                Button("Start new game") {
                    self.viewModel.startNewGame()
                }
                Text("Or join an existing game:").multilineTextAlignment(.leading)
                if self.viewModel.isLoading {
                    ProgressView().progressViewStyle(.circular)
                }
                if self.viewModel.games.count == 0 {
                    Text("There are no active games to join, try again later or start your own game.")
                }
                List{
                    ForEach(self.viewModel.games) { game in
                        Button(game.name) {
                            self.viewModel.joinGame(named: game.name)
                        }
                    }
                    Button("Reload Games") { self.viewModel.loadGames() }
                }
            }
        }
        .navigationDestination(for: Game.self) { game in
            GameView(viewModel: .init(game: game))
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
