import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String millesecondsString = "";
  GameState gameState = GameState.readyToStart;

  Timer? waitingTimer;
  Timer? stopableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.9),
              child: Text(
                "Test your \nreaction speed",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Colors.black12,
                child: SizedBox(
                  width: 300,
                  height: 160,
                  child: Center(
                    child: Text(
                      millesecondsString,
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.9),
              child: GestureDetector(
                onTap: () => setState(() {
                  switch (gameState){
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      millesecondsString = "";
                      _startWaitingTimer();
                      break;
                    case GameState.waiting:
                      gameState = GameState.canBeStopped;
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      stopableTimer?.cancel();
                      break;
                  }
                }),
                child: ColoredBox(
                  color: Colors.black12,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Text(
                        _getButtonText(),
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  String _getButtonText(){
    switch (gameState){
      case GameState.readyToStart:

        return "START";
      case GameState.waiting:
        return "WAITING";
      case GameState.canBeStopped:
        return "STOP";
    };

  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStopableTimer();
    });
  }
  void _startStopableTimer() {
    stopableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millesecondsString = "${timer.tick*16} ms";
      });
    });
  }
 @override
  void dispose() {
    waitingTimer?.cancel();
    stopableTimer?.cancel();
    super.dispose();
  }


}

enum GameState {readyToStart, waiting, canBeStopped}