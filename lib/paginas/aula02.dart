import 'package:flutter/material.dart';

class Aula02 extends StatelessWidget {
  const Aula02({super.key});

  @override
  Widget build(BuildContext context) {
    double _tamanhoIcones = 40;  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula 02 - Rows e Columns'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: _tamanhoIcones),
                Icon(Icons.person, size: _tamanhoIcones),
                Icon(Icons.settings, size: _tamanhoIcones),
              ],
            ),
            Column(),
            Column(),
          ],
        ),
      ),
    );
  }
}
