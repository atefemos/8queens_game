import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dialogs.dart';
import 'dart:math';

void main() {
  runApp(EightQueensApp());
}

class EightQueensApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eight Queens Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChessboardScreen(),
    );
  }
}

class ChessboardScreen extends StatefulWidget {
  @override
  _ChessboardScreenState createState() => _ChessboardScreenState();
}

class _ChessboardScreenState extends State<ChessboardScreen> {
  List<List<int>> board = List.generate(8, (_) => List.filled(8, 0));
  int queenCount = 0;
  String message = '';
  Color? textColor;
  IconData? trueIcon;
  int? invalidRow;
  int? invalidCol;

  @override
  void initState() {
    super.initState();
    _placeRandomQueens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('8 Queens Puzzle',
              style:
              TextStyle(color: Colors.indigo, fontWeight: FontWeight.w800)),
          centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;
                  return GestureDetector(
                    onTap: () => _toggleQueen(row, col), // toggle cell status
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: generateBgColor(row, col) // generate background color based on cell status, valid or invalid
                      ),
                      child: board[row][col] == 1
                          ? Icon(
                        Symbols.woman,
                        color: Colors.indigo,
                        size: 50,
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Wrap(
            // padding: const EdgeInsets.all(8.0),
              children: [
                Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                Icon(
                  trueIcon,
                  color: textColor,
                )
              ]),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: ElevatedButton(
              onPressed: _resetBoard,
              child: Text('Reset Board'),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleQueen(int row, int col) {
    setState(() {
      if (board[row][col] == 1) {
        board[row][col] = 0;
        queenCount--;
      } else {
        if (_isValidPlacement(row, col)) {
          board[row][col] = 1;
          queenCount++;
          message = '';
          trueIcon = null;
        } else {
          message = 'Invalid placement at row $row, column $col';
          trueIcon = Symbols.sentiment_dissatisfied;
          textColor = Colors.deepOrange;
        }
      }

      if (queenCount == 8) {
        if (_checkSolution()) {
          _showSuccessDialog(); // Display success dialog when solve
        } else {
          message = 'Incorrect solution. Try again.';
          textColor = Colors.red;
        }
      }
    });
  }

  bool _isValidPlacement(int row, int col) {
    // Check the row
    for (int i = 0; i < 8; i++) {
      if (board[row][i] == 1) {
        setState(() {
          invalidRow = row;
          invalidCol = null;
        });
        return false;
      }
    }

    // Check the column
    for (int i = 0; i < 8; i++) {
      if (board[i][col] == 1) {
        setState(() {
          invalidCol = col;
          invalidRow = null;
        });
        return false;
      }
    }

    // Check diagonals
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == 1 && (i - j == row - col || i + j == row + col)) {
          setState(() {
            invalidRow = i;
            invalidCol = j;
          });
          return false;
        }
      }
    }

    setState(() {
      invalidRow = null;
      invalidCol = null;
    });

    return true;
  }

  bool _checkSolution() {
    return queenCount == 8;
  }

  Color? generateBgColor(int row, int col) {
    if (board[row][col] != 1) {
      if ((invalidCol == null && row == invalidRow) || // invalid cells get red
          (invalidRow == null && col == invalidCol) ||
          (invalidRow != null &&
              invalidCol != null &&
              (col - row == invalidCol! - invalidRow! ||
                  row + col == invalidRow! + invalidCol!))) {
        return Colors.red[200]!;
      } else {
        return (row + col) % 2 == 0 ? Colors.white : Colors.grey;
      }
    } else {
      return Colors.green[200]!; // valid cells get green
    }
  }

  void _resetBoard() {
    setState(() {
      board = List.generate(8, (_) => List.filled(8, 3));
      queenCount = 0;
      message = '';
      textColor = null;
      trueIcon = null;
      _placeRandomQueens();
    });
  }

  void _placeRandomQueens() {
    Random rand = Random();
    int numberOfQueens = rand.nextInt(2) + 2; // Random number between 2 and 3

    for (int i = 0; i < numberOfQueens; i++) {
      bool placed = false;
      while (!placed) {
        int row = rand.nextInt(8);
        int col = rand.nextInt(8);

        if (_isValidPlacement(row, col)) {
          setState(() {
            board[row][col] = 1;
            queenCount++;
            placed = true;
          });
        }
      }
    }
  }

  void _showSuccessDialog() {
    showSuccessDialog(context, () {
      Navigator.of(context).pop();
      setState(() => _resetBoard());
    });
  }

}
