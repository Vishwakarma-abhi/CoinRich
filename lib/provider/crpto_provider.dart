// crypto_provider.dart
import 'package:coinrich/const.dart';
import 'package:coinrich/model/crpto_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoProvider extends ChangeNotifier {
  List<CryptoModel> _cryptoList = [];

  List<CryptoModel> get cryptoList => _cryptoList;

  Future<Map<String, dynamic>> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse(
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,LTC'),
      headers: {
        'Content-Type': 'application/json',
        'X-CMC_PRO_API_KEY': apikey,
      },
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
    notifyListeners();
  }
}
