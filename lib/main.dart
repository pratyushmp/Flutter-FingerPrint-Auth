import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorize_or_not = "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  Future _checkBiometric() async{
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch(e) {
      print(e);
    }
    if(!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _authorizeNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Please authenticate to complete your Auth status",
          useErrorDialogs: true,
          stickyAuth: true,
      );
    } on PlatformException catch(e) {
      print(e);
    }

    if(!mounted) return;

    setState(() {
      if(isAuthorized) {
        _authorize_or_not = "Authorized";
      }
      else {
        _authorize_or_not = "Not Authorized";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("FingerPrint Auth")),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(30)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Authorization Status: $_authorize_or_not", style: TextStyle(color: Colors.white, fontSize: 18),),
                SizedBox(height: 10,),
                RaisedButton(
                    onPressed: _authorizeNow,
                    child: Text("Authorize Now"),
                    color: Colors.green,
                    colorBrightness: Brightness.light,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

