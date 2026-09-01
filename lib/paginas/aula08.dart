import 'package:flutter/material.dart';

/// Aula 08 - Inputs
///
/// Conteúdo:
/// - Widget [TextField] e [TextFormField]
/// - Manipulação de texto com [TextEditingController]
/// - Validação e envio com [Form] e [GlobalKey<FormState>]
///
/// Projeto: Cadastro de Usuário (Perfil de Usuário)
class Aula08 extends StatefulWidget {
  const Aula08({super.key});

  @override
  State<Aula08> createState() => _Aula08State();
}

class _Aula08State extends State<Aula08> {
  // Chave global para identificar e validar o Form
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar os textos dos campos
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();

  // Variável de estado para guardar a escolha do tipo de perfil
  String _perfilSelecionado = 'Usuário Padrão';
  final List<String> _perfis = [
    'Usuário Padrão',
    'Administrador',
    'Editor',
    'Convidado',
  ];

  // Dados do usuário cadastrado para exibição na ficha
  Map<String, String>? _usuarioCadastrado;

  @override
  void dispose() {
    // Sempre descartar os controladores quando o widget for destruído
    _nomeController.dispose();
    _emailController.dispose();
    _idadeController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }

  void _cadastrarUsuario() {
    // Valida todos os campos do Form
    if (_formKey.currentState!.validate()) {
      setState(() {
        _usuarioCadastrado = {
          'nome': _nomeController.text.trim(),
          'email': _emailController.text.trim(),
          'idade': _idadeController.text.trim(),
          'cidade': _cidadeController.text.trim().isEmpty
              ? 'Não informada'
              : _cidadeController.text.trim(),
          'perfil': _perfilSelecionado,
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    _nomeController.clear();
    _emailController.clear();
    _idadeController.clear();
    _cidadeController.clear();
    setState(() {
      _perfilSelecionado = 'Usuário Padrão';
      _usuarioCadastrado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aula 08 - Inputs'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Explicação inicial
            const Text(
              'Trabalhando com Inputs em Flutter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Aprenda a utilizar TextField, TextEditingController para capturar dados '
              'e Form com TextFormField para validação de formulários.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // =========================================================
            // FORMULÁRIO DE CADASTRO DE USUÁRIO
            // =========================================================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.teal, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Cadastro de Usuário',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Campo: Nome Completo
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo',
                          hintText: 'Ex: Ana Silva',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, informe o nome.';
                          }
                          if (value.trim().length < 3) {
                            return 'O nome deve ter pelo menos 3 caracteres.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Campo: E-mail
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'ana.silva@email.com',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, informe o e-mail.';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Informe um e-mail válido.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Linha com Idade e Cidade
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _idadeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Idade',
                                hintText: 'Ex: 25',
                                prefixIcon: Icon(Icons.cake),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe a idade.';
                                }
                                final idade = int.tryParse(value);
                                if (idade == null || idade <= 0) {
                                  return 'Idade inválida.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _cidadeController,
                              decoration: const InputDecoration(
                                labelText: 'Cidade',
                                hintText: 'Ex: São Paulo',
                                prefixIcon: Icon(Icons.location_city),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Dropdown: Perfil do Usuário
                      DropdownButtonFormField<String>(
                        value: _perfilSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Perfil de Acesso',
                          prefixIcon: Icon(Icons.admin_panel_settings),
                          border: OutlineInputBorder(),
                        ),
                        items: _perfis.map((String perfil) {
                          return DropdownMenuItem<String>(
                            value: perfil,
                            child: Text(perfil),
                          );
                        }).toList(),
                        onChanged: (novoValor) {
                          if (novoValor != null) {
                            setState(() {
                              _perfilSelecionado = novoValor;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // Botões de Ação
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _limparFormulario,
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Limpar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _cadastrarUsuario,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Cadastrar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // FICHA DO USUÁRIO CADASTRADO (RESULTADO)
            // =========================================================
            if (_usuarioCadastrado != null) ...[
              const Text(
                'Perfil do Usuário Cadastrado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: Colors.teal.shade50,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _usuarioCadastrado!['nome']!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        _usuarioCadastrado!['perfil']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const Divider(height: 24),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.email, color: Colors.teal),
                        title: const Text('E-mail'),
                        subtitle: Text(_usuarioCadastrado!['email']!),
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.cake, color: Colors.teal),
                        title: const Text('Idade'),
                        subtitle: Text('${_usuarioCadastrado!['idade']} anos'),
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.location_on, color: Colors.teal),
                        title: const Text('Cidade'),
                        subtitle: Text(_usuarioCadastrado!['cidade']!),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

