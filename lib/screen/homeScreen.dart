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
// here we will store the searched Data
  Map<String, dynamic> _searchedData = {};
  @override
  void initState() {
    super.initState();
    _cryptoProvider = Provider.of<CryptoProvider>(context, listen: false);
    _cryptoProvider.fetchCryptoData();
  }

  @override
  Widget build(BuildContext context) {
    // the coin which we want to search
    TextEditingController _searchCoin = new TextEditingController();

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white),
              ),
              child: TextField(
                controller: _searchCoin,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // Handle the search icon tap

                      _searchedData = _cryptoProvider.search(_searchCoin.text);
                    },
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  hintText: 'Search',
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12),
            child: Row(
              children: [
                SizedBox(height: 15),
                Icon(
                  Icons.pie_chart_outline,
                  size: 35,
                  color: Colors.amber,
                ),
                SizedBox(width: 10),
                Text(
                  'Show Chart',
                  style: TextStyle(color: Colors.amber, fontSize: 15),
                ),
                SizedBox(width: 180),
                Consumer<CryptoProvider>(
                  builder: (context, cryptoProvider, child) {
                    final count = cryptoProvider.cryptoData.length;
                    return Text(
                      'Count $count',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 188, 186, 186),
                        fontSize: 15,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer<CryptoProvider>(
            builder: (context, cryptoProvider, child) {
              print('Crypto Container Building');
              final cryptoData = _searchedData.isNotEmpty
                  ? _searchedData
                  : cryptoProvider.cryptoData;

              if (cryptoProvider.cryptoData.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: cryptoData.length,
                    itemBuilder: (context, index) {
                      final symbol = cryptoData.keys.elementAt(index);
                      final apiData = cryptoData[symbol];
                      return CryptoContainer(apiData: apiData);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
