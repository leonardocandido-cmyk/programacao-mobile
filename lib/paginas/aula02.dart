import 'package:flutter/material.dart';

class Aula02 extends StatelessWidget {
  const Aula02({super.key});

  @override
  Widget build(BuildContext context) {
    double _tamanhoIcones = 40;
    double _alturaColuna = 200;

    Widget _construirLinha({
      required MainAxisAlignment alinhamento,
      icone1 = Icons.home,
      icone2 = Icons.person,
      icone3 = Icons.settings,
    }) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: alinhamento,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2)),
              child: Icon(icone1, size: _tamanhoIcones),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2)),
              child: Icon(icone2, size: _tamanhoIcones),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2)),
              child: Icon(icone3, size: _tamanhoIcones),
            ),
          ],
        ),
      );
    }

    Widget _construirColuna({
      required MainAxisAlignment alinhamento,
      icone1 = Icons.home,
      icone2 = Icons.person,
      icone3 = Icons.settings,
    }) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        height: _alturaColuna,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: alinhamento,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2)),
              child: Icon(icone1, size: _tamanhoIcones),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2)),
              child: Icon(icone2, size: _tamanhoIcones),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 2)),
              child: Icon(icone3, size: _tamanhoIcones),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula 02 - Rows e Columns'),
      ),
      body: SizedBox(
        width: double.infinity,
        // Cria uma barra de rolagem para o conteúdo da tela
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  "Start (Padrão)",
                ),
              ),
              _construirLinha(alinhamento: MainAxisAlignment.start),
              _construirColuna(alinhamento: MainAxisAlignment.start),
              const SizedBox(
                height: 20,
                child: Text(
                  "End (Ao final)",
                ),
              ),
              _construirLinha(
                alinhamento: MainAxisAlignment.end,
                icone1: Icons.gamepad,
                icone2: Icons.headset,
                icone3: Icons.videogame_asset,
              ),
              _construirColuna(
                alinhamento: MainAxisAlignment.end,
                icone1: Icons.gamepad,
                icone2: Icons.headset,
                icone3: Icons.videogame_asset,
              ),
              const SizedBox(
                height: 20,
                child: Text(
                  "Center (Centralizado)",
                ),
              ),
              _construirLinha(
                alinhamento: MainAxisAlignment.center,
                icone1: Icons.car_crash,
                icone2: Icons.car_rental,
                icone3: Icons.car_repair,
              ),
              _construirColuna(
                alinhamento: MainAxisAlignment.center,
                icone1: Icons.car_crash,
                icone2: Icons.car_rental,
                icone3: Icons.car_repair,
              ),
              const SizedBox(
                height: 20,
                child: Text(
                  "Space Between (Espaço entre)",
                ),
              ),
              _construirLinha(alinhamento: MainAxisAlignment.spaceBetween),
              _construirColuna(alinhamento: MainAxisAlignment.spaceBetween),
              const SizedBox(
                height: 20,
                child: Text(
                  "Space Around (Espaço ao redor)",
                ),
              ),
              _construirLinha(alinhamento: MainAxisAlignment.spaceAround),
              _construirColuna(alinhamento: MainAxisAlignment.spaceAround),
              const SizedBox(
                height: 20,
                child: Text(
                  "Space Evenly (Espaço uniforme)",
                ),
              ),
              _construirLinha(alinhamento: MainAxisAlignment.spaceEvenly),
              _construirColuna(alinhamento: MainAxisAlignment.spaceEvenly),
              // Exemplo com mainAxis e crossAxis
              const SizedBox(
                height: 20,
                child: Text(
                  "Exemplo com mainAxis e crossAxis",
                ),
              ),
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                      ),
                      child: Icon(Icons.home, size: _tamanhoIcones),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Icon(Icons.person, size: _tamanhoIcones),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow),
                      ),
                      child: Icon(Icons.settings, size: _tamanhoIcones),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.home, size: _tamanhoIcones),
                    Icon(Icons.person, size: _tamanhoIcones),
                    Icon(Icons.settings, size: _tamanhoIcones),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
