import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoContainer extends StatelessWidget {
  final dynamic apiData;

  CryptoContainer({required this.apiData});

  @override
  Widget build(BuildContext context) {
    final coinData = apiData['quote']['USD'];
    final percentChange24h = coinData['percent_change_24h'];

    // if the percent change value is in negative then we will diplay down red arrow other wise green top arrow
    final isNegative = percentChange24h < 0;
    final absolutePercentChange = percentChange24h.abs();

    // Rounding off Price value
    final price = double.parse(coinData['price'].toStringAsFixed(2));

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 1.0),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Text(
                    // name of the crpto currency
                    apiData['name'],
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Price Arraow and Percent values
                Padding(
                  padding: const EdgeInsets.only(left: 50, top: 12),
                  child: Icon(
                    isNegative ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isNegative ? Colors.red : Colors.green,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 12),
                  child: Text(
                    '${absolutePercentChange.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isNegative ? Colors.red : Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 70, top: 12),
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(144, 158, 158, 158)),
                      child: Center(
                        child: Text(
                          '${apiData['symbol']}',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            // Price and Ranking
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12),
                  child: Text(
                    // \u0024 is the dollar sign unicode
                    "Price  " + '\u0024 ${price}',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),

                // rank of the crpto currency
                Padding(
                  padding: const EdgeInsets.only(left: 55, top: 12),
                  child: Text(
                    "Rank  " + '${apiData['cmc_rank']}',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 70, top: 12),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
