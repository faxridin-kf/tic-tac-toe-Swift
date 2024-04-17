import Foundation
import SwiftUI

enum Player: String {
    case x, o
}

struct Square {
    var player: Player? // Holds 'X', 'O', or nil (empty)
}

class TicTacToeGame: ObservableObject {
    @Published var board: [[Square]] // Game board (2D array)
    @Published var currentPlayer: Player // Current player ('X' or 'O')
    @Published var winner: Player? // Track the winner if any
    @Published var isBoardFull: Bool // Check if all squares are filled
    
    private var winningCombinations: [[Int]] // Predefined winning combinations
    
    init() {
        board = Array(repeating: Array(repeating: Square(), count: 3), count: 3)
        currentPlayer = .x // Start with 'X'
        winner = nil
        isBoardFull = false
        
        winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6] // Diagonals
        ]
    }
    
    func placeMark(at row: Int, col: Int) {
        guard board[row][col].player == nil else { return } // Prevent overwriting
        
        board[row][col].player = currentPlayer
        currentPlayer = currentPlayer == .x ? .o : .x // Switch players
        
        checkWinner() // Check for a winner after each move
    }
    
    func checkWinner() {
        for combination in winningCombinations {
            if let player = board[combination[0]][combination[1]].player,
               player == board[combination[1]][combination[2]].player,
               player == board[combination[0]][combination[2]].player {
                objectWillChange.send() // Trigger UI update on winner
                winner = player
                return
            }
        }
        
        isBoardFull = board.allSatisfy { row in
            return row.allSatisfy { $0.player != nil }
        }
        
        if isBoardFull { // Check for a tie
            objectWillChange.send()
            winner = nil
        }
    }
}
