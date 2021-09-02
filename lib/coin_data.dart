import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'USD',
  'EUR',
  'UAH',
  'BRL',
  'CAD',
  'CNY',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'AUD',
  'ZAR'
];

const List<String> cryptoList = ['BTC', 'SC', 'XRP'];

const coinURL = 'https://rest.coinapi.io/v1/exchangerate';
const API_KEY = 'B3AE87F5-EA85-4B03-9CE7-245FB558A578';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '$coinURL/$crypto/$selectedCurrency?apikey=$API_KEY';
      http.Response response = await http.get(Uri.parse(requestURL));

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(3);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
