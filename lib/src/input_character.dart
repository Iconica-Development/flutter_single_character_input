// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class InputCharacter {
  const InputCharacter({
    required this.keyboardType,
    this.readOnly = false,
    this.hint = '',
    this.formatter,
  });

  final TextInputType keyboardType;
  final CharacterFormatter? formatter;
  final bool readOnly;
  final String hint;

  String format(String value) => formatter?.call(value) ?? value;
}

typedef CharacterFormatter = String Function(String);
