import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class EthService {
  late Web3Client _client;
  late String _privateKey;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;

  // Replace with your Ganache RPC URL and deployed contract address
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _contractAddress = "0x7Ae7063bB9c0a2630907f8d1424ad566B7cDb930";

  EthService() {
    _client = Web3Client(_rpcUrl, Client());

    // Private key initialization (make sure it's a valid hex string)
    _privateKey =
        '0xa2ad8717c8191829b4c43c23d11a77157c4f90af139eb2b2832a660e37fd950c'; // Example: '0xabc123...'

    // Initialize credentials from the private key
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  // Load the SmartBike contract ABI and deployed contract
  Future<void> loadContract() async {
    // Load the contract's ABI from the assets folder
    String abi = await rootBundle.loadString('assets/SmartBikeABI.json');

    _contract = DeployedContract(
      ContractAbi.fromJson(abi, "SmartBike"),
      EthereumAddress.fromHex(_contractAddress),
    );
  }

  // Function to rent a bike
  Future<String> rentBike(int bikeId) async {
    final function = _contract.function('rentBike');

    // Send a transaction to rent a bike with the given bikeId
    final result = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: function,
        parameters: [BigInt.from(bikeId)], // Parameters for rentBike
      ),
      chainId: 1337, // Set chainId if required (for Ganache it's usually 1337)
    );
    return result;
  }

  // Function to return a bike
  Future<String> returnBike() async {
    final function = _contract.function('returnBike');

    // Send a transaction to return a bike
    final result = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: function,
        parameters: [], // No parameters needed for returnBike
      ),
      chainId: 1337, // Set chainId if required
    );
    return result;
  }

  // Get bike details by bikeId
  Future<List<dynamic>> getBike(int bikeId) async {
    final function = _contract.function('bikes');

    // Call the bikes function to get bike details
    final result = await _client.call(
      contract: _contract,
      function: function,
      params: [BigInt.from(bikeId)],
    );
    return result;
  }
}
