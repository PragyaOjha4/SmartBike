import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'eth_service.dart';

void main() => runApp(SmartBikeApp());

Future<String> loadABI() async {
  return await rootBundle.loadString('assets/SmartBikeABI.json');
}

class SmartBikeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SmartBikeHome(),
    );
  }
}

class SmartBikeHome extends StatefulWidget {
  @override
  _SmartBikeHomeState createState() => _SmartBikeHomeState();
}

class _SmartBikeHomeState extends State<SmartBikeHome> {
  EthService ethService = EthService();
  String transactionResult = '';

  @override
  void initState() {
    super.initState();
    ethService.loadContract(); // Load the contract when app starts
  }

  void rentBike() async {
    String result = await ethService.rentBike(1); // Rent bike with ID 1
    setState(() {
      transactionResult = result;
    });
  }

  void returnBike() async {
    String result = await ethService.returnBike(); // Return rented bike
    setState(() {
      transactionResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Bike System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: rentBike,
              child: Text('Rent Bike'),
            ),
            ElevatedButton(
              onPressed: returnBike,
              child: Text('Return Bike'),
            ),
            SizedBox(height: 20),
            Text('Transaction Result: $transactionResult'),
          ],
        ),
      ),
    );
  }
}
