import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolsa de Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Inicial'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var client = http.Client();
                try {
                  var response = await client.get(
                      Uri.parse('http://localhost:8090/api/v1/jfa/por-data?data=2024-09-01'));
                  if (response.statusCode == 200) {
                    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
                    print('Resposta da API:');
                    print(decodedResponse);
                  } else {
                    print('Falha na requisição: ${response.statusCode}');
                  }
                } catch (e) {
                  print('Erro na requisição: $e');
                } finally {
                  client.close();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdutosPage()),
                );
              },
              child: const Text('Bolsa de Produtos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilPage()),
                );
              },
              child: const Text('Perfil'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
                );
              },
              child: const Text('Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolsa de Produtos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: const [
          ProdutoCard(nome: 'FONTE 40A', porcentagem: 25, quantidade: 10),
          ProdutoCard(nome: 'FONTE LITE 40A', porcentagem: 20, quantidade: 15),
          ProdutoCard(nome: 'FONTE 60A', porcentagem: 30, quantidade: 8),
          ProdutoCard(nome: 'FONTE LITE 60A', porcentagem: 28, quantidade: 12),
        ],
      ),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Página de Perfil'),
      ),
    );
  }
}

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Página de Configurações'),
      ),
    );
  }
}

class ProdutoCard extends StatelessWidget {
  final String nome;
  final int porcentagem;
  final int quantidade;

  const ProdutoCard({super.key, required this.nome, required this.porcentagem, required this.quantidade});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              porcentagem >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: porcentagem >= 0 ? Colors.green : Colors.red,
            ),
            Text(
              '${porcentagem.abs()}%',
              style: TextStyle(
                color: porcentagem >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Text(
          'Qtd: $quantidade',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}