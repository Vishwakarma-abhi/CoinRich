import 'dart:convert';
import 'package:coinrich/const.dart';
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

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      _cryptoData = json.decode(response.body)['data'];
      notifyListeners();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
