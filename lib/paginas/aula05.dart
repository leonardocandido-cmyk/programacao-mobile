import 'package:flutter/material.dart';

/// Aula 05 - Imagens e Assets
///
/// Conteúdo:
/// 1. Image.asset (Carregando o logo do Flutter armazenado em assets/images/flutter_logo.png)
/// 2. Image.network (Carregando uma imagem de natureza de um repositório público na internet)
/// 3. Propriedade BoxFit (cover, contain, fill)
class Aula05 extends StatelessWidget {
  const Aula05({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula 05 - Imagens e Assets'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =========================================================
            // 1. IMAGEM LOCAL (IMAGE.ASSET) - LOGO DO FLUTTER
            // =========================================================
            const Text(
              '1. Imagem Local (Image.asset)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Imagem carregada dos arquivos locais do projeto (assets/images/flutter_logo.png):',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/flutter_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.flutter_dash, size: 50, color: Colors.blue),
                                  Text('Logo do Flutter (assets)'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Logo do Flutter (Asset Local)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // 2. IMAGEM DA INTERNET (IMAGE.NETWORK) - NATUREZA
            // =========================================================
            const Text(
              '2. Imagem da Internet (Image.network)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Imagem de natureza consumida de um repositório público (Unsplash / Picsum):',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Image.network(
                    'https://picsum.photos/id/1015/600/300',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        color: Colors.teal.shade50,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Paisagem Natural (Repositório Público)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // 3. PROPRIEDADE BOXFIT (EXEMPLOS COM A IMAGEM DE NATUREZA)
            // =========================================================
            const Text(
              '3. Ajustes de Imagem (BoxFit)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFitExample(
                    'BoxFit.cover',
                    BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFitExample(
                    'BoxFit.contain',
                    BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFitExample(
                    'BoxFit.fill',
                    BoxFit.fill,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Helper para exemplificar BoxFit em imagens
  Widget _buildFitExample(String label, BoxFit fit) {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              'https://picsum.photos/id/1015/300/200',
              fit: fit,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.teal.shade50,
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.teal),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
