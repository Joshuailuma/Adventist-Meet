import 'package:flutter/material.dart';

class Hello extends StatefulWidget {
  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.black12,
          child: ElevatedButton(
            onPressed: () {
              //To show a snackbar
              final snackBar = SnackBar(content: Text('You have pressed me'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text('Press this'),
          ),
        ),
      ),
    );
  }
}
