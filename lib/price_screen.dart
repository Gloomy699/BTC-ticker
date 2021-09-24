import 'package:bitcoin_ticker/crypto_card.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> _dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      _dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: _selectedCurrency,
      items: _dropdownItems,
      onChanged: (value) {
        setState(() {
          _selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> _pickerItems = [];
    for (String currency in currenciesList) {
      _pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          _selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: _pickerItems,
    );
  }

  Map<String, String> _coinValues = {};
  bool _isWaiting = false;

  void getData() async {
    _isWaiting = true;
    try {
      var data = await CoinData().getCoinData(_selectedCurrency);
      _isWaiting = false;
      setState(() {
        _coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCards() {
    List<CryptoCard> _cryptoCards = [];
    for (String _crypto in cryptoList) {
      _cryptoCards.add(
        CryptoCard(
          cryptoCurrency: _crypto,
          selectedCurrency: _selectedCurrency,
          value: _isWaiting ? '?' : _coinValues[_crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
