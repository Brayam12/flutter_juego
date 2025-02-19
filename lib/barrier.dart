import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {

  final size;
  //Constructor que inicializa el tamaño de la barrera
  MyBarrier({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
       //Define el ancho fijo de la barrera
      width: 80,
      //La altura se ajusta según el parametro proporcionado 
      height: size,
      //Estiliza la barrera con color y bordes
      decoration: BoxDecoration(
        color: Colors.green, //Color de la barrera
        border: Border.all(width: 10, color: Colors.lightGreen,), //Color del bordes de la barrera 
      ),
    );
  }
}