import 'package:flutter/material.dart';

class Aula01 extends StatelessWidget {
  const Aula01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("01 - Container"),
      ),
      body: Center(
        // Column organiza verticalmente o conteúdo.
        child: Column(
          children: [
            // Container com largura e altura
            Container(
              // Double.infinity faz com que o container ocupe toda a largura disponível
              width: double.infinity,
              height: 100,
              color: Colors.blue, // Define a cor de fundo do container
              child: Center(
                child: Text("Container com largura e altura"),
              ),
            ),
            // Container com padding e margin
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              color: Colors.red,
              child: Center(
                child: Text(
                  "Container com padding e margin",
                  // Define o estilo do texto
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Container com decoration
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green,
                // Define a borda do container
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                // Define o arredondamento dos cantos do container
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text("Container com borda e arredondamento"),
              ),
            ),
            // Container com transformação
            Container(
              width: 200,
              height: 100,
              color: Colors.yellow,
              child: Center(
                child: Text("Container com transformação"),
              ),
              transform: Matrix4.rotationZ(0.1), // Rotaciona o container
            ),
          ],
        ),
      ),
    );
  }
}
