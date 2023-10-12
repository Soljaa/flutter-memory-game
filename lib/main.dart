import 'package:flutter/material.dart';
import 'package:jogo_da_memoria/home.dart';

void main() {
  runApp(MaterialApp(
    title: "Jogo da Memoria",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Jujutsu'),
    home: const Home(),
  ));
}