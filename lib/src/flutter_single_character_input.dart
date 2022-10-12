import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SingleCharacterInput extends StatefulWidget {
  const SingleCharacterInput({super.key});

  @override
  State<SingleCharacterInput> createState() => _SingleCharacterInputState();
}

class _SingleCharacterInputState extends State<SingleCharacterInput> {
  @override
  Widget build(BuildContext context) {
    return const Text('HELLO THERE');
  }
}
