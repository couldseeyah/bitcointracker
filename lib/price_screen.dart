import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'networking.dart';
import 'coin_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String apiKey = '03BD5C75-9A21-4C7C-9667-0F23693C4D7B';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool loading = true;
  String selectedCurrency = 'USD';
  String btcRate = '?';
  String ethRate = '?';
  String ltcRate = '?';

  List<Widget> getPickerList() {
    List<Widget> pickerList = [];
    for (int i = 0; i < currenciesList.length; i++) {
      pickerList.add(Text(currenciesList[i]));
    }
    return pickerList;
  }

  Widget showError() {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 235, 248, 255),
      title: Text(
        'Error',
        style: TextStyle(color: Color.fromARGB(255, 8, 9, 9), fontSize: 18.0),
      ),
      content: Text(
        'Request limit reached! Please try again later.',
        style:
            TextStyle(color: Color.fromARGB(255, 27, 45, 45), fontSize: 16.0),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void getCoinData() async {
    String btcrate = '?';
    String ethrate = '?';
    String ltcrate = '?';

    NetworkService networkServiceBTC = NetworkService(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=$apiKey');
    NetworkService networkServiceETH = NetworkService(
        'https://rest.coinapi.io/v1/exchangerate/ETH/$selectedCurrency?apikey=$apiKey');
    NetworkService networkServiceLTC = NetworkService(
        'https://rest.coinapi.io/v1/exchangerate/LTC/$selectedCurrency?apikey=$apiKey');

    var coinDataBTC = await networkServiceBTC.getData();
    var coinDataETH = await networkServiceETH.getData();
    var coinDataLTC = await networkServiceLTC.getData();

    if (coinDataBTC != null && coinDataETH != null && coinDataLTC != null) {
      btcrate = coinDataBTC['rate'].toStringAsFixed(2);
      ethrate = coinDataETH['rate'].toStringAsFixed(2);
      ltcrate = coinDataLTC['rate'].toStringAsFixed(2);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showError();
        },
      );
    }

    setState(() {
      btcRate = btcrate;
      ethRate = ethrate;
      ltcRate = ltcrate;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCoinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coin Ticker ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            Icon(
              Icons.monetization_on,
              color: Colors.yellowAccent,
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10.0),
          loading
              ? SpinKitWanderingCubes(
                  color: Color.fromARGB(255, 142, 190, 189),
                  size: 50.0,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BitcoinCard(
                      rate: btcRate,
                      selectedCurrency: selectedCurrency,
                      coinType: 'BTC',
                    ),
                    BitcoinCard(
                      rate: ethRate,
                      selectedCurrency: selectedCurrency,
                      coinType: 'ETH',
                    ),
                    BitcoinCard(
                      rate: ltcRate,
                      selectedCurrency: selectedCurrency,
                      coinType: 'LTC',
                    ),
                  ],
                ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFF03D3CF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )),
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            child: Listener(
              onPointerUp: (event) {
                setState(() {
                  loading = true;
                });
                getCoinData();
              },
              child: CupertinoPicker(
                itemExtent: 32.0,
                onSelectedItemChanged: (selectedIndex) {
                  setState(() {
                    selectedCurrency = currenciesList[selectedIndex];
                  });
                },
                children: getPickerList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BitcoinCard extends StatelessWidget {
  const BitcoinCard({
    super.key,
    required this.rate,
    required this.selectedCurrency,
    required this.coinType,
  });

  final String rate;
  final String selectedCurrency;
  final String coinType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
      child: Card(
        color: Color(0xFF03D3CF),
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinType = $rate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
