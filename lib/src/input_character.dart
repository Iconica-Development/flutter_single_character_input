// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

/// Defines a character input configuration.
class InputCharacter {
  /// Creates an [InputCharacter] configuration.
  ///
  /// The [keyboardType] parameter is required.
  /// The [readOnly], [hint], and [formatter] parameters are optional.
  const InputCharacter({
    required this.keyboardType,
    this.readOnly = false,
    this.hint = '',
    this.formatter,
  });

  /// The type of keyboard to display for the input.
  final TextInputType keyboardType;

  /// A flag indicating whether the input is read-only.
  final bool readOnly;

  /// The optional hint text displayed inside the input field.
  final String hint;

  /// The optional formatter function to format the input value.
  final CharacterFormatter? formatter;

  /// Formats the input value using the provided formatter function.
  ///
  /// If no formatter is provided, the input value remains unchanged.
  String format(String value) => formatter?.call(value) ?? value;
}

/// Defines a function signature for formatting input characters.
typedef CharacterFormatter = String Function(String);
