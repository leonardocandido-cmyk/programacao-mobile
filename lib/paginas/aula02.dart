import 'package:flutter/material.dart';

class Aula02 extends StatelessWidget {
  const Aula02({super.key});

  @override
  Widget build(BuildContext context) {
    //Construindo widget customizavel (Reaproveitamento de código)
    Widget _construirLinha(
      MainAxisAlignment alinhamento, // Alinhamento por parâmetro
      IconData icone1, // Icones por parâmetro
      IconData icone2,
      IconData icone3,
    ) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        // Criando uma linha que alinha seu conteúdo no início
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: alinhamento,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Icon(icone1),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Icon(icone2),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Icon(icone3),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Aula 02 - Rows e Columns"),
      ),
      // Cria uma barra de rolagem para o conteúdo da tela
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
              child: Text("Start (Padrão)"),
            ),
            _construirLinha(
              MainAxisAlignment.start,
              Icons.seven_k_rounded,
              Icons.eight_k_rounded,
              Icons.nine_k_rounded,
            ),
            // Definido uma coluna
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              height: 200,
              // Criando uma coluna que alinha seu conteúdo no início
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Icon(Icons.one_k_outlined),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Icon(Icons.access_time_filled_rounded),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Icon(Icons.account_tree_sharp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
