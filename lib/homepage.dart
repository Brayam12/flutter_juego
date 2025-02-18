import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_juego/barrier.dart';
import 'package:flutter_juego/bird.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXuno = 1;
  double barrierXdos = barrierXuno + 1.5;


  static double birdWidth = 0.08;
  static double birdHeight = 0.8;
  static double barrierWidth = .5;
  static double barrierHeight = .6;


  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }


  bool checkCollision() {
    
    double birdLeft = -birdWidth / 2;
    double birdRight = birdWidth / 2;
    double birdTop = birdYaxis - birdHeight / 2;
    double birdBottom = birdYaxis + birdHeight / 2;

    
    bool collisionWithBarrier(double barrierX, double barrierY) {
      double barrierLeft = barrierX - barrierWidth / 2;
      double barrierRight = barrierX + barrierWidth / 2;
      double barrierTop = barrierY - barrierHeight / 2;
      double barrierBottom = barrierY + barrierHeight / 2;

      return birdRight > barrierLeft &&
          birdLeft < barrierRight &&
          birdBottom > barrierTop &&
          birdTop < barrierBottom;
    }

    
    if (collisionWithBarrier(barrierXuno, -1.1) ||
        collisionWithBarrier(barrierXuno, 1.1) || 
        collisionWithBarrier(barrierXdos, -1.1) ||
        collisionWithBarrier(barrierXdos, 1.1)) 
        {
      return true;
    }

    return false;
  }

 
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
        
        if (barrierXuno < -2) {
          barrierXuno += 3.5;
        } else {
          barrierXuno -= 0.05;
        }

        if (barrierXdos < -2) {
          barrierXdos += 3.5;
        } else {
          barrierXdos -= 0.05;
        }
      });


      // Verificar colisión
      if (checkCollision() || birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
        showGameOver();
      }
    });
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("JUEGO TERMINADO")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text("Reintentar"),
            ),

          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      initialHeight = birdYaxis;
      barrierXuno = 1;
      barrierXdos = barrierXuno + 1.5;
      gameHasStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  Container(
                    alignment: Alignment(-0.3, -0.3),
                    child: gameHasStarted
                        ? Text("")
                        : Text(
                            "PULSA PARA JUGAR",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXuno, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXuno, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXdos, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXdos, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 250.0,
                    ),
                  ),                 
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}