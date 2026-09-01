import 'package:flutter/material.dart';

/// Tela de Configurações da Aula 06
///
/// Demonstrando a tela final do fluxo (Menu -> Perfil -> Configurações)
class Aula06Configuracoes extends StatelessWidget {
  const Aula06Configuracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
        backgroundColor: Colors.amber.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificações'),
            subtitle: Text('Ativar avisos do aplicativo'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Tema Escuro'),
            subtitle: Text('Alternar para modo noturno'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacidade e Segurança'),
            subtitle: Text('Gerenciar dados da conta'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                // Voltar para a tela anterior
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar para a tela anterior'),
            ),
          ),
        ],
      ),
    );
  }
}
