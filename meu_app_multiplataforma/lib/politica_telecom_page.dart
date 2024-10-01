import 'package:share_plus/share_plus.dart';
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
      body:SingleChildScrollView(
      child: Column(
        children: politicaJfaData.map((data) {
          return GestureDetector(
            onTap: () => launch(data['link']),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    data['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Modelo: ${data['model']}',
                          style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Preço: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(data['price'])}',
                          style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Preço Previsto: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(data['predicted_price'])}',
                          style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tipo: ${data['listing_type'] == 'gold_pro' ? 'Premium' : 'Clássico'}',
                          style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data['link'],
                                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                Share.share('''${data['model']} - ${data['seller']} - Preço Anúncio: ${data['price']} - Preço Política: ${data['predicted_price']} (${data['listing_type'] == 'gold_pro' ? 'Premium' : 'Clássico'}) ${data['link']}''');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    )
    );
  }
}