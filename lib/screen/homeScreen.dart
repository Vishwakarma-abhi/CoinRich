import 'dart:convert';
import 'package:coinrich/widgets/crpto_cont.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _cryptoData;

  @override
  void initState() {
    super.initState();
    _cryptoData = fetchCryptoData();
  }

  Future<Map<String, dynamic>> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse(
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,LTC'),
      headers: {
        'Content-Type': 'application/json',
        'X-CMC_PRO_API_KEY': '27ab17d1-215f-49e5-9ca4-afd48810c149',
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 84, 80, 80),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              'CoinRich',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _cryptoData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final cryptoData = snapshot.data!['data'];

                    // Create a list of CryptoContainer
                    List<Widget> cryptoContainers =
                        cryptoData.keys.map<Widget>((symbol) {
                      final apiData = cryptoData[symbol];
                      return CryptoContainer(apiData: apiData);
                    }).toList();

                    // Ensure that cryptoContainers is of type List<Widget>
                    List<Widget> typedCryptoContainers =
                        List<Widget>.from(cryptoContainers);
                    final count = typedCryptoContainers.length;
                    return Column(
                      children: [
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Icon(
                                Icons.pie_chart_outline,
                                size: 35,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Show Chart',
                                style: TextStyle(
                                    color: Colors.amber, fontSize: 15),
                              ),
                              SizedBox(
                                width: 180,
                              ),
                              Text(
                                'Count ' + count.toString(),
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 188, 186, 186),
                                    fontSize: 15),
                              )
                            ],
                          ),
                        ),
                        ...typedCryptoContainers
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
