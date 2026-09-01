import 'package:flutter/material.dart';
import 'package:flutter_app/my_home_page.dart';
import 'package:flutter_app/paginas/aula01.dart';
import 'package:flutter_app/paginas/aula02.dart';
import 'package:flutter_app/paginas/aula03.dart';
import 'package:flutter_app/paginas/aula04.dart';
import 'package:flutter_app/paginas/aula05.dart';
import 'package:flutter_app/paginas/aula06/aula06.dart';
import 'package:flutter_app/paginas/aula06/perfil.dart';
import 'package:flutter_app/paginas/aula06/configuracoes.dart';
import 'package:flutter_app/paginas/aula07/aula07.dart';
import 'package:flutter_app/paginas/aula07/jogo_da_velha.dart';
import 'package:flutter_app/paginas/aula08.dart';
import 'package:flutter_app/paginas/modulo2/aula09.dart';
import 'package:flutter_app/paginas/modulo2/aula10.dart';
import 'package:flutter_app/paginas/modulo2/aula11.dart';
import 'package:flutter_app/paginas/modulo2/aula12.dart';
import 'package:flutter_app/paginas/modulo3/aula13.dart';
import 'package:flutter_app/paginas/modulo3/aula14.dart';
import 'package:flutter_app/paginas/modulo3/aula15.dart';
import 'package:flutter_app/paginas/modulo3/aula16.dart';
import 'package:flutter_app/paginas/modulo3/aula17.dart';
import 'package:flutter_app/paginas/modulo3/aula18.dart';

final Map<String, WidgetBuilder> appRoutes = {
  "/": (context) => const MyHomePage(title: 'Página Principal'),
  "/aula01": (context) => const Aula01(),
  "/aula02": (context) => const Aula02(),
  "/aula03": (context) => const Aula03(),
  "/aula04": (context) => const Aula04(),
  "/aula05": (context) => const Aula05(),
  "/aula06": (context) => const Aula06(),
  "/aula06/perfil": (context) => const Aula06Perfil(),
  "/aula06/configuracoes": (context) => const Aula06Configuracoes(),
  "/aula07": (context) => const Aula07(),
  "/aula07/jogo_da_velha": (context) => const JogoDaVelhaPage(),
  "/aula08": (context) => const Aula08(),
  "/aula09": (context) => const Aula09(),
  "/aula10": (context) => const Aula10(),
  "/aula11": (context) => const Aula11(),
  "/aula12": (context) => const Aula12(),
  "/aula13": (context) => const Aula13(),
  "/aula14": (context) => const Aula14(),
  "/aula15": (context) => const Aula15(),
  "/aula16": (context) => const Aula16(),
  "/aula17": (context) => const Aula17(),
  "/aula18": (context) => const Aula18(),
};
