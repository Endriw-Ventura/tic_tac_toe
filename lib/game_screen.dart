// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  bool oTurn = true;
  List<String> display = ['', '', '', '', '', '', '', '', ''];
  String result = '';
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;
  bool firstPlay = true;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Player O',
                        style: TextStyle(
                            fontSize: 35
                        ),
                      ),
                      Text(oScore.toString(),
                        style: TextStyle(
                            fontSize: 35
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Player X',
                        style: TextStyle(
                            fontSize: 35
                        ),
                      ),
                      Text(xScore.toString(),
                        style: TextStyle(
                            fontSize: 35
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => _clicked(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 5
                          ),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(display[index],
                            style: TextStyle(
                              fontSize: 64,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    Text(result),
                    _buildTimer()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clicked(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if(!winnerFound && isRunning){
      setState(() {
        if (oTurn && display[index].isEmpty) {
          display[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && display[index].isEmpty) {
          display[index] = 'X';
          filledBoxes++;
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    //check lines
    //line 1
    if (display[0].isNotEmpty && display[0] == display[1] &&
        display[0] == display[2]) {
      setState(() {
        result = 'Player ${display[0]} Wins!';
        _updateScore(display[0]);
      });
    }
    //line 2
    if (display[3].isNotEmpty && display[3] == display[4] &&
        display[3] == display[5]) {
      setState(() {
        result = 'Player ${display[3]} Wins!';
        _updateScore(display[3]);
      });
    }
    //line 3
    if (display[6].isNotEmpty && display[6] == display[7] &&
        display[6] == display[8]) {
      setState(() {
        result = 'Player ${display[6]} Wins!';
        _updateScore(display[6]);
      });
    }

    //check columns
    //column 1
    if (display[0].isNotEmpty && display[0] == display[3] &&
        display[0] == display[6]) {
      setState(() {
        result = 'Player ${display[0]} Wins!';
        _updateScore(display[0]);
      });
    }
    //column 2
    if (display[1].isNotEmpty && display[1] == display[4] &&
        display[1] == display[7]) {
      setState(() {
        result = 'Player ${display[1]} Wins!';
        _updateScore(display[1]);
      });
    }
    //column 3
    if (display[2].isNotEmpty && display[2] == display[5] &&
        display[2] == display[8]) {
      setState(() {
        result = 'Player ${display[2]} Wins!';
        _updateScore(display[2]);
      });
    }

    //check diagonals
    //diagonal 1
    if (display[0].isNotEmpty && display[0] == display[4] &&
        display[0] == display[8]) {
      setState(() {
        result = 'Player ${display[0]} Wins!';
        _updateScore(display[0]);
      });
    }
    //diagonal 2
    if (display[2].isNotEmpty && display[2] == display[4] &&
        display[2] == display[6]) {
      setState(() {
        result = 'Player ${display[2]} Wins!';
        _updateScore(display[2]);
      });
    }
    //check tie
    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        result = "Its a tie!";
        _stopTimer();
      });
    }
  }

  _updateScore(String winner) {
    if (!winnerFound && winner == 'O') {
      oScore++;
      winnerFound = true;
      _stopTimer();
    } else if (!winnerFound && winner == 'X') {
      xScore++;
      winnerFound = true;
      _stopTimer();
    }
  }

  void _clearBoard() {
    setState(() {
      filledBoxes = 0;
      result = '';
      winnerFound = false;
      oTurn = true;
      display = ['', '', '', '', '', '', '', '', ''];
      firstPlay = false;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _resetTimer();
    timer?.cancel();
  }

  void _resetTimer() => seconds = maxSeconds;

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning && !winnerFound ?
    SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.red),
            strokeWidth: 8,
            backgroundColor: Colors.blue,
          ),
          Center(
            child: Text('$seconds',
            style: TextStyle(
              fontSize: 35
            ),
            ),
          )
        ],
      ),
    )
        : ElevatedButton(
      onPressed: () {
        _startTimer();
        _clearBoard();
      },
      child: Text(firstPlay ? 'Start!' :'Play Again!'),
    );
  }
}

