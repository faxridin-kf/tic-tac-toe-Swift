import Foundation
import SwiftUI

enum Player: String {
    case x, o
}

struct Square {
    var player: Player?
}

class TicTacToeGame: ObservableObject {
    @Published var board: [[Square]]
    @Published var currentPlayer: Player
    @Published var winner: Player?
    @Published var isBoardFull: Bool
    
    private var winningCombinations: [[Int]]
    
    init() {
        board = Array(repeating: Array(repeating: Square(), count: 3), count: 3)
        currentPlayer = .x
        winner = nil
        isBoardFull = false
        
        winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
    }
    
    func placeMark(at row: Int, col: Int) {
        guard board[row][col].player == nil else { return }
        
        board[row][col].player = currentPlayer
        currentPlayer = currentPlayer == .x ? .o : .x
        
        checkWinner()
    }
    
    func checkWinner() {
        for combination in winningCombinations {
            if let player = board[combination[0]][combination[1]].player,
               player == board[combination[1]][combination[2]].player,
               player == board[combination[0]][combination[2]].player {
                objectWillChange.send()
                winner = player
                return
            }
        }
        
        isBoardFull = board.allSatisfy { row in
            return row.allSatisfy { $0.player != nil }
        }
        
        if isBoardFull {
            objectWillChange.send()
            winner = nil
        }
    }
}
