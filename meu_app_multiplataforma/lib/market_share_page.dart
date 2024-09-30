import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:meu_app_multiplataforma/configuracoes_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class MarketSharePage extends StatefulWidget {
  const MarketSharePage({super.key});

  @override
  _MarketSharePageState createState() => _MarketSharePageState();
}

class _MarketSharePageState extends State<MarketSharePage> {
  List<Map<String, dynamic>> marketShareData = [];
  List<Map<String, dynamic>> marketShareDataUsinaTable = [];
  List<Map<String, dynamic>> marketShareDataTarampsTable = [];
  List<Map<String, dynamic>> marketShareDataStetsomTable = [];
  List<Map<String, dynamic>> marketShareDataJfa = [];
  List<Map<String, dynamic>> marketShareDataUsina = [];
  List<Map<String, dynamic>> marketShareDataStetsom = [];
  List<Map<String, dynamic>> marketShareDataTarmps = [];
  List<_SalesData> totalSellsData = [];
  List<_SalesData> totalSellsDataControle = [];
  List<_SalesData> totalSellsDataStetsom = [];
  List<_SalesData> totalSellsDataStetsomControle = [];
  List<_SalesData> totalSellsDataTaramps = [];
  List<_SalesData> totalSellsDataUsina = [];
  late DateTime now;
  late DateTime dataInicio;
  late DateTime dataFim;
  late String dataInicioFormatada;
  late String dataFimFormatada;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    dataInicio = DateTime(now.year, now.month, 1);
    dataFim = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
    dataInicioFormatada =
        "${dataInicio.year}-${dataInicio.month.toString().padLeft(2, '0')}-${dataInicio.day.toString().padLeft(2, '0')}";
    dataFimFormatada =
        "${dataFim.year}-${dataFim.month.toString().padLeft(2, '0')}-${dataFim.day.toString().padLeft(2, '0')}";
    _fetchMarketShareData();
    _fetchTotalSells();
    _fetchTotalSellsStetsom();
    _fetchTotalSellsTaramps();
    _fetchTotalSellsUsina();
  }

  Future<void> _selectDateInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dataInicio,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != dataInicio) {
      setState(() {
        dataInicio = picked;
        dataInicioFormatada = DateFormat('yyyy-MM-dd').format(dataInicio);
      });
      _fetchMarketShareData();
      _fetchTotalSells();
      _fetchTotalSellsStetsom();
      _fetchTotalSellsTaramps();
      _fetchTotalSellsUsina();
    }
  }

  Future<void> _selectDateFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dataFim,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != dataFim)
      setState(() {
        dataFim = picked;
        dataFimFormatada =
            "${dataFim.year}-${dataFim.month.toString().padLeft(2, '0')}-${dataFim.day.toString().padLeft(2, '0')}";
      });
    _fetchMarketShareData();
    _fetchTotalSells();
    _fetchTotalSellsStetsom();
    _fetchTotalSellsTaramps();
    _fetchTotalSellsUsina();
  }

  Future<void> _fetchMarketShareData() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/jfa/market-share?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareData = decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/stetsom/market-share?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataStetsomTable =
              decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/taramps/market-share?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataTarampsTable =
              decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/usina/market-share?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataUsinaTable =
              decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/jfa/get-by-date-range-grouped-by-model?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataJfa = decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/usina/get-by-date-range-grouped-by-model?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataUsina = decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/taramps/get-by-date-range-grouped-by-model?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataTarmps = decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }

      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/stetsom/get-by-date-range-grouped-by-model?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          marketShareDataStetsom = decodedResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    } finally {
      client.close();
    }
  }

  Future<void> _fetchTotalSells() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/jfa/quantidades-por-intervalo?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          totalSellsData = decodedResponse
              .map((item) => _SalesData(
                  DateFormat('yyyy-MM-dd').parse(item['date']),
                  item['quantity'].toDouble()))
              .toList();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/jfa/quantidades-por-intervalo-controle?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          totalSellsDataControle = decodedResponse
              .map((item) => _SalesData(
                  DateFormat('yyyy-MM-dd').parse(item['date']),
                  item['quantity'].toDouble()))
              .toList();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    } finally {
      client.close();
    }
  }

  Future<void> _fetchTotalSellsStetsom() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/stetsom/quantidades-por-intervalo?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          totalSellsDataStetsom = decodedResponse
              .map((item) => _SalesData(
                  DateFormat('yyyy-MM-dd').parse(item['date']),
                  item['quantity'].toDouble()))
              .toList();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
      response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/stetsom/quantidades-por-intervalo-controle?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          totalSellsDataStetsomControle = decodedResponse
              .map((item) => _SalesData(
                  DateFormat('yyyy-MM-dd').parse(item['date']),
                  item['quantity'].toDouble()))
              .toList();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    } finally {
      client.close();
    }
  }

  Future<void> _fetchTotalSellsTaramps() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/taramps/quantidades-por-intervalo?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          totalSellsDataTaramps = decodedResponse
              .map((item) => _SalesData(
                  DateFormat('yyyy-MM-dd').parse(item['date']),
                  item['quantity'].toDouble()))
              .toList();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    } finally {
      client.close();
    }
  }

  List<_SalesData> calculatePercentageData(
      List<_SalesData> dataJFA, List<_SalesData> dataStetsom) {
    List<_SalesData> percentageData = [];

    for (int i = 0; i < dataJFA.length; i++) {
      final totalSales = dataJFA[i].sales + dataStetsom[i].sales;
      final percentageJFA = (dataJFA[i].sales / totalSales) * 100;
      final percentageStetsom = (dataStetsom[i].sales / totalSales) * 100;

      percentageData.add(_SalesData(dataJFA[i].date, percentageJFA));
      percentageData.add(_SalesData(dataStetsom[i].date, percentageStetsom));
    }

    return percentageData;
  }

  Future<void> _fetchTotalSellsUsina() async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://expertinvest.com.br/api/v1/usina/quantidades-por-intervalo?dataInicio=$dataInicioFormatada&dataFim=$dataFimFormatada'));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          totalSellsDataUsina = decodedResponse
              .map((item) => _SalesData(
                  DateFormat('yyyy-MM-dd').parse(item['date']),
                  item['quantity'].toDouble()))
              .toList();
        });
      } else {
        print('Falha na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Share'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDateInicio(context),
                    child: Text(
                        "Selecionar Data Início: ${DateFormat('dd/MM/yyyy').format(dataInicio)}"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _selectDateFim(context),
                    child: Text(
                        "Selecionar Data Fim: ${DateFormat('dd/MM/yyyy').format(dataFim)}"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'JFA',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Família',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Qtd',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Valor',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                  ...marketShareData.map((item) => TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['familia'] ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['quantidade']?.toString() ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$')
                                .format(item['valor'] ?? 0)),
                          )),
                        ],
                      )),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          marketShareData
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(marketShareData.fold(0.0,
                                  (sum, item) => sum + (item['valor'] ?? 0))),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              const Text(
                'STETSOM',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Família',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Qtd',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Valor',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                  ...marketShareDataStetsomTable.map((item) => TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['familia'] ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['quantidade']?.toString() ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$')
                                .format(item['valor'] ?? 0)),
                          )),
                        ],
                      )),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          marketShareDataStetsomTable
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(marketShareDataStetsomTable.fold(0.0,
                                  (sum, item) => sum + (item['valor'] ?? 0))),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              const Text(
                'TARAMPS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Família',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Qtd',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Valor',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                  ...marketShareDataTarampsTable.map((item) => TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['familia'] ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['quantidade']?.toString() ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$')
                                .format(item['valor'] ?? 0)),
                          )),
                        ],
                      )),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          marketShareDataTarampsTable
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(marketShareDataTarampsTable.fold(0.0,
                                  (sum, item) => sum + (item['valor'] ?? 0))),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              const Text(
                'USINA',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Família',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Qtd',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Valor',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                    ],
                  ),
                  ...marketShareDataUsinaTable.map((item) => TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['familia'] ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['quantidade']?.toString() ?? ''),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$')
                                .format(item['valor'] ?? 0)),
                          )),
                        ],
                      )),
                  TableRow(
                    children: [
                      const TableCell(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          marketShareDataUsinaTable
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(marketShareDataUsinaTable.fold(0.0,
                                  (sum, item) => sum + (item['valor'] ?? 0))),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JFA',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('PRODUTO',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('QTD',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                        ],
                      ),
                      ...marketShareDataJfa.map((item) => TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['familia'] ?? ''),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(item['quantidade']?.toString() ?? ''),
                              )),
                            ],
                          )),
                      TableRow(
                        children: [
                          const TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Total',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              marketShareDataJfa
                                  .fold<int>(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          (item['quantidade'] as int? ?? 0))
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'USINA',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('PRODUTO',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('QTD',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                        ],
                      ),
                      ...marketShareDataUsina.map((item) => TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['familia'] ?? ''),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(item['quantidade']?.toString() ?? ''),
                              )),
                            ],
                          )),
                      TableRow(
                        children: [
                          const TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Total',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              marketShareDataUsina
                                  .fold<int>(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          (item['quantidade'] as int? ?? 0))
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'STETSOM',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('PRODUTO',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('QTD',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                        ],
                      ),
                      ...marketShareDataStetsom.map((item) => TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['familia'] ?? ''),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(item['quantidade']?.toString() ?? ''),
                              )),
                            ],
                          )),
                      TableRow(
                        children: [
                          const TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Total',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              marketShareDataStetsom
                                  .fold<int>(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          (item['quantidade'] as int? ?? 0))
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TARAMPS',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('PRODUTO',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('QTD',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                        ],
                      ),
                      ...marketShareDataTarmps.map((item) => TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item['familia'] ?? ''),
                              )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(item['quantidade']?.toString() ?? ''),
                              )),
                            ],
                          )),
                      TableRow(
                        children: [
                          const TableCell(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Total',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              marketShareDataTarmps
                                  .fold<int>(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          (item['quantidade'] as int? ?? 0))
                                  .toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Análise de vendas diária FONTES (QTD)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd/MM/yyyy'),
                    intervalType: DateTimeIntervalType.days,
                  ),
                  legend: const Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_SalesData, DateTime>>[
                    ColumnSeries<_SalesData, DateTime>(
                      dataSource: totalSellsData,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Vendas',
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Análise de Vendas Diárias FONTES (QTD)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd/MM'),
                    intervalType: DateTimeIntervalType.days,
                  ),
                  legend: const Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_SalesData, DateTime>>[
                    LineSeries<_SalesData, DateTime>(
                      dataSource: totalSellsData,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'JFA',
                      color: Colors.blue,
                    ),
                    LineSeries<_SalesData, DateTime>(
                      dataSource: totalSellsDataStetsom,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Stetsom',
                      color: Colors.red,
                    ),
                    LineSeries<_SalesData, DateTime>(
                      dataSource: totalSellsDataTaramps,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Taramps',
                      color: Colors.green,
                    ),
                    LineSeries<_SalesData, DateTime>(
                      dataSource: totalSellsDataUsina,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Usina',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Análise de Vendas Diárias CONTROLE (QTD)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd/MM'),
                    intervalType: DateTimeIntervalType.days,
                  ),
                  legend: const Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_SalesData, DateTime>>[
                    LineSeries<_SalesData, DateTime>(
                      dataSource: totalSellsDataControle,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'JFA',
                      color: Colors.blue,
                    ),
                    LineSeries<_SalesData, DateTime>(
                      dataSource: totalSellsDataStetsomControle,
                      xValueMapper: (_SalesData sales, _) => sales.date,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Stetsom',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Market Share por FONTES (QTD)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<Map<String, dynamic>, String>(
                      dataSource: [
                        {
                          'marca': 'JFA',
                          'quantidade': marketShareData
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                        },
                        {
                          'marca': 'Stetsom',
                          'quantidade': marketShareDataStetsomTable
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                        },
                        {
                          'marca': 'Taramps',
                          'quantidade': marketShareDataTarampsTable
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                        },
                        {
                          'marca': 'Usina',
                          'quantidade': marketShareDataUsinaTable
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<int>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['quantidade'] as int? ?? 0))
                        },
                      ],
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['marca'] as String,
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['quantidade'] as int,
                      dataLabelMapper: (Map<String, dynamic> data, _) {
                        int total = marketShareData
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<int>(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        (item['quantidade'] as int? ?? 0)) +
                            marketShareDataStetsomTable
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<int>(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        (item['quantidade'] as int? ?? 0)) +
                            marketShareDataTarampsTable
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<int>(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        (item['quantidade'] as int? ?? 0)) +
                            marketShareDataUsinaTable
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<int>(
                                    0, (sum, item) => sum + (item['quantidade'] as int? ?? 0));
                        double percentage = (data['quantidade'] / total) * 100;
                        return '${data['marca']}: ${percentage.toStringAsFixed(1)}%';
                      },
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Market Share por FONTES (Valor em R\$)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<Map<String, dynamic>, String>(
                      dataSource: [
                        {
                          'marca': 'JFA',
                          'valor': marketShareData
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['valor'] as double? ?? 0))
                        },
                        {
                          'marca': 'Stetsom',
                          'valor': marketShareDataStetsomTable
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['valor'] as double? ?? 0))
                        },
                        {
                          'marca': 'Taramps',
                          'valor': marketShareDataTarampsTable
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['valor'] as double? ?? 0))
                        },
                        {
                          'marca': 'Usina',
                          'valor': marketShareDataUsinaTable
                              .where((item) => item['familia'] == 'FONTE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['valor'] as double? ?? 0))
                        },
                      ],
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['marca'] as String,
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['valor'] as double,
                      dataLabelMapper: (Map<String, dynamic> data, _) {
                        double total = marketShareData
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['valor'] as double? ?? 0)) +
                            marketShareDataStetsomTable
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['valor'] as double? ?? 0)) +
                            marketShareDataTarampsTable
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['valor'] as double? ?? 0)) +
                            marketShareDataUsinaTable
                                .where((item) => item['familia'] == 'FONTE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['valor'] as double? ?? 0));
                        double percentage = (data['valor'] / total) * 100;
                        return '${data['marca']}: ${percentage.toStringAsFixed(1)}%';
                      },
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              const Text(
                'Market Share por CONTROLE (QTD)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<Map<String, dynamic>, String>(
                      dataSource: [
                        {
                          'marca': 'JFA',
                          'quantidade': marketShareData
                              .where((item) => item['familia'] == 'CONTROLE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum +
                                      (item['quantidade'] as double? ?? 0))
                        },
                        {
                          'marca': 'Stetsom',
                          'quantidade': marketShareDataStetsomTable
                              .where((item) => item['familia'] == 'CONTROLE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum +
                                      (item['quantidade'] as double? ?? 0))
                        },
                      ],
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['marca'] as String,
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['quantidade'] as double,
                      dataLabelMapper: (Map<String, dynamic> data, _) {
                        double total = marketShareData
                                .where((item) => item['familia'] == 'CONTROLE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        (item['quantidade'] as double? ?? 0)) +
                            marketShareDataStetsomTable
                                .where((item) => item['familia'] == 'CONTROLE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        (item['quantidade'] as double? ?? 0));
                        double percentage = (data['quantidade'] / total) * 100;
                        return '${data['marca']}: ${percentage.toStringAsFixed(1)}%';
                      },
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              const Text(
                'Market Share por CONTROLE (Valor em R\$)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<Map<String, dynamic>, String>(
                      dataSource: [
                        {
                          'marca': 'JFA',
                          'valor': marketShareData
                              .where((item) => item['familia'] == 'CONTROLE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['valor'] as double? ?? 0))
                        },
                        {
                          'marca': 'Stetsom',
                          'valor': marketShareDataStetsomTable
                              .where((item) => item['familia'] == 'CONTROLE')
                              .fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum + (item['valor'] as double? ?? 0))
                        },
                      ],
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['marca'] as String,
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['valor'] as double,
                      dataLabelMapper: (Map<String, dynamic> data, _) {
                        double total = marketShareDataStetsomTable
                                .where((item) => item['familia'] == 'CONTROLE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['valor'] as double? ?? 0)) +
                            marketShareData
                                .where((item) => item['familia'] == 'CONTROLE')
                                .fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['valor'] as double? ?? 0));
                        double percentage = (data['valor'] / total) * 100;

                        return '${data['marca']}: ${percentage.toStringAsFixed(1)}%';
                      },
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
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

class _SalesData {
  _SalesData(this.date, this.sales);

  final DateTime date;
  final double sales;
}
