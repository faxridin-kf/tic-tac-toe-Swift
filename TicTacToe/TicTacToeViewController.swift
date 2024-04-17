import UIKit

enum Player: String {
    case x, o
}

class TicTacToeViewController: UIViewController {

    @IBOutlet weak var boardView: UIStackView! // Grid container
    @IBOutlet weak var currentPlayerLabel: UILabel!

    private var board: [UIButton?] = Array(repeating: nil, count: 9) // Represents the game board
    private var currentTurn: Player = .x // Starting player

    override func viewDidLoad() {
        super.viewDidLoad()
        createBoard()
        currentPlayerLabel.text = "Current Player: \(currentTurn.rawValue.uppercased())"
    }

    private func createBoard() {
        for i in 0..<9 {
            let button = UIButton(type: .system)
            button.tag = i // Assign a unique tag for button identification
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            boardView.addArrangedSubview(button)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        guard let buttonIndex = sender.tag else { return }

        if let currentSymbol = board[buttonIndex]?.currentTitle, !currentSymbol.isEmpty {
            // Square already occupied, show an alert (optional)
            presentAlert(title: "Oops!", message: "This square is already taken.")
            return
        }

        board[buttonIndex] = sender
        sender.setTitle(currentTurn.rawValue.uppercased(), for: .normal) // Set symbol
        sender.isEnabled = false // Disable button after placement

        if checkForWin() {
            gameOver(message: "\(currentTurn.rawValue.uppercased()) wins!")
        } else if isBoardFull() {
            gameOver(message: "It's a tie!")
        } else {
            // Switch turns
            currentTurn = currentTurn == .x ? .o : .x
            currentPlayerLabel.text = "Current Player: \(currentTurn.rawValue.uppercased())"
        }
    }

    private func checkForWin() -> Bool {
        // Check all winning conditions using nested loops
        let winningConditions = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]

        for condition in winningConditions {
            if let symbol1 = board[condition[0]]?.currentTitle,
               symbol1 == symbol1,
               symbol1 == board[condition[1]]?.currentTitle,
               symbol1 == board[condition[2]]?.currentTitle {
                return true // Winning condition met
            }
        }

        return false
    }

    private func isBoardFull() -> Bool {
        // Check if all buttons have titles (meaning filled)
        return board.filter { $0?.currentTitle?.isEmpty == true }.isEmpty
    }

    private func gameOver(message: String) {
        // Display an alert with the game result and reset option
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Reset", style: .default) { _ in
            self.resetGame()
        }
        alert.addAction(resetAction)
        present(alert, animated: true)

        // Optionally, disable all buttons to prevent further interaction
        for button in board {
            button?.isEnabled = false
        }
    }

    private func resetGame() {
        for i in 0..<9 {
            board[i]?.setTitle(nil, for: .normal)
            board[i]?.isEnabled = true
        }
        currentTurn = .x // Reset starting player
        currentPlayerLabel.text = "Current Player: X"
    }

    private func presentAlert(title: String, message: String) {
        // Optional alert presentation for additional user feedback
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
