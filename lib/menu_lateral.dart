import 'package:flutter/material.dart';

class MenuLateral extends StatefulWidget {
  const MenuLateral({super.key});

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_esports, size: 36, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Curso de Programação Mobile',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Flutter, PokéAPI & Flame 2D',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // --- MÓDULO 1 ---
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 12, bottom: 4),
            child: Text(
              "MÓDULO 1 - FUNDAMENTOS FLUTTER",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.crop_square),
            title: const Text("01 - Container"),
            onTap: () => Navigator.pushNamed(context, "/aula01"),
          ),
          ListTile(
            leading: const Icon(Icons.view_column),
            title: const Text("02 - Linhas e colunas"),
            onTap: () => Navigator.pushNamed(context, "/aula02"),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("03 - Meu perfil"),
            onTap: () => Navigator.pushNamed(context, "/aula03"),
          ),
          ListTile(
            leading: const Icon(Icons.smart_button),
            title: const Text("04 - Textos e Botões"),
            onTap: () => Navigator.pushNamed(context, "/aula04"),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("05 - Imagens e Assets"),
            onTap: () => Navigator.pushNamed(context, "/aula05"),
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text("06 - Ícones e Navegação"),
            onTap: () => Navigator.pushNamed(context, "/aula06"),
          ),
          ListTile(
            leading: const Icon(Icons.touch_app),
            title: const Text("07 - StatefulWidget"),
            onTap: () => Navigator.pushNamed(context, "/aula07"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              leading: const Icon(Icons.grid_on, size: 20),
              title: const Text(
                "Atividade - Jogo da Velha",
                style: TextStyle(fontSize: 14),
              ),
              onTap: () => Navigator.pushNamed(context, "/aula07/jogo_da_velha"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text("08 - Inputs"),
            onTap: () => Navigator.pushNamed(context, "/aula08"),
          ),

          const Divider(),

          // --- MÓDULO 2 ---
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              "MÓDULO 2 - CONSUMO DE APIS (POKÉAPI)",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.api, color: Colors.redAccent),
            title: const Text("09 - Introdução às APIs REST"),
            onTap: () => Navigator.pushNamed(context, "/aula09"),
          ),
          ListTile(
            leading: const Icon(Icons.http, color: Colors.redAccent),
            title: const Text("10 - Primeira Requisição HTTP"),
            onTap: () => Navigator.pushNamed(context, "/aula10"),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.redAccent),
            title: const Text("11 - Pokédex com FutureBuilder"),
            onTap: () => Navigator.pushNamed(context, "/aula11"),
          ),
          ListTile(
            leading: const Icon(Icons.catching_pokemon, color: Colors.redAccent),
            title: const Text("12 - Pokédex Completa"),
            onTap: () => Navigator.pushNamed(context, "/aula12"),
          ),

          const Divider(),

          // --- MÓDULO 3 ---
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              "MÓDULO 3 - JOGO 2D COM BONFIRE (FLAME)",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sports_esports, color: Colors.purple),
            title: const Text("13 - Bonfire e Personagem"),
            onTap: () => Navigator.pushNamed(context, "/aula13"),
          ),
          ListTile(
            leading: const Icon(Icons.map, color: Colors.purple),
            title: const Text("14 - Mapas, Câmera e Colisões"),
            onTap: () => Navigator.pushNamed(context, "/aula14"),
          ),
          ListTile(
            leading: const Icon(Icons.forum, color: Colors.purple),
            title: const Text("15 - NPCs e Interação"),
            onTap: () => Navigator.pushNamed(context, "/aula15"),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.purple),
            title: const Text("16 - Inimigos, Vida e Dano"),
            onTap: () => Navigator.pushNamed(context, "/aula16"),
          ),
          ListTile(
            leading: const Icon(Icons.assignment, color: Colors.purple),
            title: const Text("17 - Itens, Missões e HUD"),
            onTap: () => Navigator.pushNamed(context, "/aula17"),
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset, color: Colors.purple),
            title: const Text("18 - Fluxo Completo & DS Quest"),
            onTap: () => Navigator.pushNamed(context, "/aula18"),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
