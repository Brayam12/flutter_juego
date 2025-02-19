import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
        //Define el tamaño del contenedor del pajaro
      height: 60, //Altura del pajaro
      width: 60, //Ancho del pajaro

      //Carga la imagen del pajaro desde los assets
      child: Image.asset(
      'lib/images/bird.png'
      ),
    );
  }
}