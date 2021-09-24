import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'USD',
  'EUR',
  'UAH',
  // 'BRL',
  // 'CAD',
  // 'CNY',
  // 'GBP',
  // 'HKD',
  // 'IDR',
  // 'ILS',
  // 'INR',
  // 'JPY',
  // 'MXN',
  // 'NOK',
  // 'NZD',
  // 'PLN',
  // 'RON',
  // 'RUB',
  // 'SEK',
  // 'SGD',
  // 'AUD',
  // 'ZAR'
];

const List<String> cryptoList = ['BTC', 'SC', 'XRP'];

const _coinURL = 'https://rest.coinapi.io/v1/exchangerate';
const _API_KEY = 'B3AE87F5-EA85-4B03-9CE7-245FB558A578';

class CoinData {
  Future getCoinData(String _selectedCurrency) async {
    Map<String, String> _cryptoPrices = {};
    for (String _crypto in cryptoList) {
      String requestURL =
          '$_coinURL/$_crypto/$_selectedCurrency?apikey=$_API_KEY';
      http.Response response = await http.get(Uri.parse(requestURL));

      if (response.statusCode == 200) {
        var _decodedData = jsonDecode(response.body);
        double _price = _decodedData['rate'];
        _cryptoPrices[_crypto] = _price.toStringAsFixed(3);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return _cryptoPrices;
  }
}
