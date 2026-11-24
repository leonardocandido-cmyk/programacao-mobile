import 'package:flutter/material.dart';
import 'package:flutter_app/my_home_page.dart';
import 'package:flutter_app/paginas/aula01.dart';
import 'package:flutter_app/paginas/aula02.dart';
import 'package:flutter_app/paginas/aula03.dart';
import 'package:flutter_app/paginas/aula04/aula04.dart';

final Map<String, WidgetBuilder> appRoutes = {
  "/": (context) => const MyHomePage(title: 'Página Principal'),
  "/aula01": (context) => const Aula01(),
  "/aula02": (context) => const Aula02(),
  "/aula03": (context) => const Aula03(),
  "/aula04":(context) => const Aula04(),
  "/aula04/jogo_velha":(context) => const Aula04()
};