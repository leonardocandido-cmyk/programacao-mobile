import 'package:flutter/material.dart';

/// Stateless -> Sem estado (Não muda as informações na tela)
/// Stateful  -> Têm alteração de estado (Modifica a estrutura da tela)
class Aula04 extends StatefulWidget {
  const Aula04({super.key});

  @override
  State<Aula04> createState() => _Aula04State();
}

class _Aula04State extends State<Aula04> {
  /// TextEditingController -> Permite manipular os valores
  /// inseridos em campo de texto
  final _novaTarefaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de Estados - Stateful"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Stateful"),
      ),
    );
  }
}
