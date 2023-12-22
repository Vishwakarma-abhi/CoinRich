import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coinrich/const.dart';

class CryptoProvider extends ChangeNotifier {
  late Map<String, dynamic> _cryptoData = {};

  Map<String, dynamic> get cryptoData => _cryptoData;

  Future<void> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse(
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,LTC',
      ),
      headers: {
        'Content-Type': 'application/json',
        'X-CMC_PRO_API_KEY': apikey,
      },
    );
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      _cryptoData = json.decode(response.body)['data'];
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Map<String, dynamic> search(String query) {
    List<Map<String, dynamic>> searchResults = [];
    Map<String, dynamic> searchedData = {};
    _cryptoData.forEach((symbol, cryptoInfo) {
      String symbolLowerCase = symbol.toLowerCase();
      String nameLowerCase = cryptoInfo['name'].toLowerCase();

      if (symbolLowerCase.contains(query.toLowerCase()) ||
          nameLowerCase.contains(query.toLowerCase())) {
        searchResults.add(cryptoInfo);

        searchResults.forEach((element) {
          cryptoData.addAll(element);
        });
      }
    });
    notifyListeners();

    return searchedData;
    // Print the search results
    // printSearchResults(searchResults);
  }

  void printSearchResults(List<Map<String, dynamic>> searchResults) {
    for (var result in searchResults) {
      print('Symbol: ${result['symbol']}');
      print('Name: ${result['name']}');
      print('Price: ${result['quote']['USD']['price']}');
      // Add other relevant information you want to print
      print('--------------');
    }
  }
}
