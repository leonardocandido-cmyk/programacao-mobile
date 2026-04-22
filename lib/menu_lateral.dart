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
              color: Colors.blue,
            ),
            child: Text(
              'Curso Flutter',
              style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }
}
