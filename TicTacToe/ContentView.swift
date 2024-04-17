import SwiftUI

struct ContentView: View {
    @StateObject private var game = TicTacToeGame() // Manage game state
    
    var body: some View {
        VStack {
            Spacer() // Add some space at the top
            
            Text("Tic Tac Toe") // Title
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer() // More space
            
            LazyVStack {
                ForEach(0..<game.board.count, id: \.self) { row in
                    HStack {
                        ForEach(0..<game.board[row].count, id: \.self) { col in
                            cellView(for: game.board[row][col].player)
                                .onTapGesture {
                                    game.placeMark(at: row, col: col) // Handle player tap
                                }
                                .frame(width: 50, height: 50) // Set square size
                                .background(Color.gray.opacity(0.2)) // Light border for each square
                        }
                    }
                }
            }
            .frame(width: 200, height: 200) // Set board size
            
            // ... (rest of the code)
            
        }
    }
    
    func cellView(for player: Player?) -> some View {
        switch player {
        case .x:
            return Text("X")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
        case .o:
            return Text("O")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        case nil:
            return Text("")
        }
    }
}
