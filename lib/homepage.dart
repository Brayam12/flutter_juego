import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_juego/barrier.dart';
import 'package:flutter_juego/bird.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Posición inicial del pájaro en el eje Y
  static double birdYaxis = 0;
  double time = 0; //Variable para calcular el movimiento del pajaro
  double height = 0; //Variable para calcular la altura del pajaro
  double initialHeight = birdYaxis; //Guarda la altura inicial del pájaro antes del salto
  bool gameHasStarted = false; //Variable para saber si el juego ha comenzado
  static double barrierXuno = 1; //Posición inicial de la primera barrera en el eje X
  double barrierXdos = barrierXuno + 1.5; //Posición inicial de la segunda barrera en el eje X
  int puntuacion = 0; // Variable para la puntuación

  // Dimensiones del pájaro y los obstáculos
  static double birdWidth = 0.08; //Ancho del pajaro
  static double birdHeight = 0.8; //Alto del pajaro
  static double barrierWidth = .5; //Ancho de la barrera
  static double barrierHeight = .6; //Alto de la barrera

  // Método para hacer que el pájaro salte
  void jump() {
    setState(() {
      time = 0; //Reinicia el tiempo para calcular la nueva altura
      initialHeight = birdYaxis; //Guarda la posición actual como punto de partida
    });
  }

  // Método para verificar si el pájaro ha colisionado con los obstáculos
  bool checkCollision() {
    // Definir los límites del pájaro
    double birdLeft = -birdWidth / 2; //Límite izquierdo del pájaro
    double birdRight = birdWidth / 2; //Límite derecho del pájaro
    double birdTop = birdYaxis - birdHeight / 2; //Límite superior del pájaro
    double birdBottom = birdYaxis + birdHeight / 2; //Límite inferior del pájaro

    // Función para verificar colisión con un obstáculo
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

    // Verificar colisión con cada obstáculo
    if (collisionWithBarrier(barrierXuno, -1.1) || // Obstáculo superior 1
        collisionWithBarrier(barrierXuno, 1.1) ||  // Obstáculo inferior 1
        collisionWithBarrier(barrierXdos, -1.1) || // Obstáculo superior 2
        collisionWithBarrier(barrierXdos, 1.1)) {  // Obstáculo inferior 2
      return true; // Hay colisión
    }

    return false; // No hay colisión
  }

  // Método para verificar la puntuación
  void _checkScore() {
    if ((barrierXuno < -birdWidth / 2 && barrierXuno > -birdWidth / 2 - 0.05) ||
        (barrierXdos < -birdWidth / 2 && barrierXdos > -birdWidth / 2 - 0.05)) {
      setState(() {
        puntuacion++; //Se incrementa la puntuación si se pasa un obstáculo
      });
    }
  }

  // Método para iniciar el juego
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time; //Calcula la trayectoria del pajaro
      setState(() {
        birdYaxis = initialHeight - height; //Actualiza la posición del pajaro
        // Movimiento de los obstáculos
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

      // Verificar puntuación
      _checkScore();

      // Verificar colisión
      if (checkCollision() || birdYaxis > 1) {
        timer.cancel(); //Detiene el juego
        gameHasStarted = false;
        showGameOver(); //Muestra el mensaje de juego terminado
      }
    });
  }

  // Método para mostrar el mensaje de "Juego terminado"
  void showGameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("JUEGO TERMINADO")), //Mensaje de juego terminado
          content: Text("Puntuación: $puntuacion", textAlign: TextAlign.center), //Mostrar la puntuación
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame(); //Reiniciar el juego
              },
              child: Text("Reintentar"),
            ),

          ],
        );
      },
    );
  }

  // Método para reiniciar el juego
  void resetGame() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      initialHeight = birdYaxis;
      barrierXuno = 1;
      barrierXdos = barrierXuno + 1.5;
      gameHasStarted = false;
      puntuacion = 0; // Reiniciar la puntuación
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detecta toques en la pantalla para iniciar el juego o hacer que el pájaro salte
      onTap: () {
        if (gameHasStarted) {
          jump(); //Si el juego ha comenzado, el pájaro salta
        } else {
          startGame(); //Si el juego no ha comenzado, se inicia el juego
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Fondo del cielo con el pájaro animado
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue, //Color del cielo
                    child: MyBird(), //Añade el pájaro al fondo del cielo
                  ),
                  // Mensaje inicial antes de que comience el juego
                  Container(
                    alignment: Alignment(-0.3, -0.3),
                    child: gameHasStarted
                        ? Text("")
                        : Text(
                            "PULSA PARA JUGAR", //Mensaje de inicio
                            style: TextStyle(
                              fontSize: 25, //Tamaño del texto
                              color: Colors.white, //Color del texto
                            ),
                          ),
                  ),
                  // Barreras animadas que se mueven de derecha a izquierda
                  AnimatedContainer(
                    alignment: Alignment(barrierXuno, -1.1), //Posición de la barrera superior
                    duration: Duration(milliseconds: 0), //Duración de la animación
                    child: MyBarrier(
                      size: 200.0, //Tamaño de la barrera
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
                  // Mostrar la puntuación
                  Positioned(
                    top: 50, //Posición de la puntuación
                    right: 20, //Posición de la puntuación
                    child: Text(
                      'Puntuación: $puntuacion', //Texto de la puntuación
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white, //Color del texto
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Suelo del juego
            Container(
              height: 15, //Altura del suelo
              color: Colors.green, //Color del suelo
            ),
            // Base marrón inferior del juego
            Expanded(
              child: Container(
                color: Colors.brown, //Color de la base
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Espacio entre los elementos
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}