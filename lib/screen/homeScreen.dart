import 'package:coinrich/provider/crpto_provider.dart';
import 'package:coinrich/widgets/crpto_cont.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CryptoProvider _cryptoProvider;

  @override
  void initState() {
    super.initState();
    _cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    _cryptoProvider.fetchCryptoData();
  }

  @override
  Widget build(BuildContext context) {
    print('Scaffold build');
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
              child: Consumer<CryptoProvider>(
                builder: (context, cryptoProvider, child) {
                  // Conditions before building the CrptoContainer Widget
                  if (cryptoProvider.cryptoData.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    print('Crpto Container Building');
                    final cryptoData = cryptoProvider.cryptoData;

                    // Since we are using the CrptoContainer Class wiget so that is why we use List<Widget> and then convert it into list
                    List<Widget> cryptoContainers =
                        cryptoData.keys.map<Widget>((symbol) {
                      final apiData = cryptoData[symbol];
                      return CryptoContainer(apiData: apiData);
                    }).toList();
                    
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
                                'Count $count',
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
