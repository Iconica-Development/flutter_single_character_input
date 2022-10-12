import 'package:flutter/material.dart';
import 'package:flutter_single_character_input/flutter_single_character_input.dart';

void main() {
  runApp(const MaterialApp(home: FlutterSingleCharacterInputDemo()));
}

class FlutterSingleCharacterInputDemo extends StatelessWidget {
  const FlutterSingleCharacterInputDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleCharacterInput(),
    );
  }
}
