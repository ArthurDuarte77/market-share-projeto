import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PoliticaTelecomJfaPage extends StatefulWidget {
  const PoliticaTelecomJfaPage({super.key});

  @override
  _PoliticaTelecomJfaPageState createState() => _PoliticaTelecomJfaPageState();
}

class _PoliticaTelecomJfaPageState extends State<PoliticaTelecomJfaPage> {
  List<dynamic> politicaJfaData = [];

  @override
  void initState() {
    super.initState();
    _fetchPoliticaJfaData();
  }

  _fetchPoliticaJfaData() async {
    final response = await http.get(Uri.parse('https://expertinvest.com.br/api/v1/politica-telecom'));
    if (response.statusCode == 200) {
      setState(() {
        politicaJfaData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load politica JFA data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politica TELECOM JFA'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: politicaJfaData.map((data) => ListTile(
            leading: Image.network(data['image'], fit: BoxFit.cover, width: 100, height: 100,),
            title: Text(data['title'], overflow: TextOverflow.ellipsis),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Modelo: ${data['model']}', overflow: TextOverflow.ellipsis),
                Text('Preço: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(data['price'])}', overflow: TextOverflow.ellipsis),
                Text('Preço Previsto: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(data['predicted_price'])}', overflow: TextOverflow.ellipsis),
                Text('Tipo: ${data['listing_type'] == 'gold_pro' ? 'Premium' : 'Clássico'}', overflow: TextOverflow.ellipsis),
                InkWell(
                  child: Text(data['link'], overflow: TextOverflow.ellipsis),
                  onTap: () => launch(data['link']),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }
}