import SwiftUI

struct ContentView: View {
    @StateObject private var game = TicTacToeGame()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer() // More space
            
            LazyVStack {
                ForEach(0..<game.board.count, id: \.self) { row in
                    HStack {
                        ForEach(0..<game.board[row].count, id: \.self) { col in
                            cellView(for: game.board[row][col].player)
                                .onTapGesture {
                                    game.placeMark(at: row, col: col)
                                }
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.2))
                        }
                    }
                }
            }
            .frame(width: 200, height: 200)
            
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
