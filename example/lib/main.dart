// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_single_character_input/single_character_input.dart';

void main() {
  runApp(const MaterialApp(home: FlutterSingleCharacterInputDemo()));
}

class FlutterSingleCharacterInputDemo extends StatefulWidget {
  const FlutterSingleCharacterInputDemo({Key? key}) : super(key: key);

  @override
  State<FlutterSingleCharacterInputDemo> createState() =>
      _FlutterSingleCharacterInputDemoState();
}

class _FlutterSingleCharacterInputDemoState
    extends State<FlutterSingleCharacterInputDemo> {
  CharacterFormatter get _numberFormatter => (String value) {
        if (RegExp('[0-9]').hasMatch(value)) {
          return value;
        }
        return '';
      };

  CharacterFormatter get _textFormatter => (String value) {
        if (RegExp('[A-Za-z]').hasMatch(value)) {
          return value.toUpperCase();
        }
        return '';
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleCharacterInput(
          characters: [
            InputCharacter(
              hint: '1',
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              formatter: _numberFormatter,
            ),
            InputCharacter(
              hint: '2',
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              formatter: _numberFormatter,
            ),
            InputCharacter(
              hint: '3',
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              formatter: _numberFormatter,
            ),
            InputCharacter(
              hint: '4',
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              formatter: _numberFormatter,
            ),
            InputCharacter(
              hint: 'A',
              keyboardType: TextInputType.name,
              formatter: _textFormatter,
            ),
            InputCharacter(
              hint: 'B',
              keyboardType: TextInputType.name,
              formatter: _textFormatter,
            ),
          ],
          textStyle: Theme.of(context).textTheme.headline1?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 28,
              ),
          inputDecoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFBBBBBB),
                  fontSize: 28,
                ),
            isDense: true,
            isCollapsed: true,
          ),
          buildDecoration: (context, input) {
            return Container(
              margin: const EdgeInsets.all(5),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: 32,
                child: input,
              ),
            );
          },
          onChanged: (value, finished) {
            // setState(() {});
          },
        ),
      ),
    );
  }
}
