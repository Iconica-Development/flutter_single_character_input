import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_single_character_input/src/input_character.dart';

class SingleCharacterInput extends StatefulWidget {
  const SingleCharacterInput({
    required this.characters,
    required this.onChanged,
    this.textAlign = TextAlign.center,
    this.cursorTextAlign = TextAlign.center,
    this.buildCustomInput,
    this.buildDecoration,
    this.inputDecoration,
    this.spacing = 0,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, List<Widget> inputs)?
      buildCustomInput;

  /// Called when building a single input. Can be used to wrap the input.
  final Widget Function(BuildContext context, Widget input)? buildDecoration;

  /// Gets called when the value is changed.
  /// Passes the changed value and if all inputs are filled in.
  final void Function(String value, bool isComplete) onChanged;

  final InputDecoration? inputDecoration;

  /// List of all character fields which are used to create inputs.
  final List<InputCharacter> characters;

  final TextAlign textAlign;
  final TextAlign cursorTextAlign;
  final double spacing;
  final TextStyle? textStyle;

  @override
  State<SingleCharacterInput> createState() => _SingleCharacterInputState();
}

class _SingleCharacterInputState extends State<SingleCharacterInput>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _mainController;
  late final Map<TextInputType, FocusNode> _mainNodes;
  String _currentValue = '';
  int _currentIndex = 0;
  late TextInputType _currentKeyboard;
  late Animation _cursorAnimation;
  late AnimationController _cursorAnimationController;

  @override
  void initState() {
    super.initState();
    _mainController = TextEditingController();
    _mainNodes = widget.characters
        .asMap()
        .map((key, value) => MapEntry(value.keyboardType, FocusNode()));
    _currentKeyboard = widget.characters.first.keyboardType;
    _cursorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cursorAnimation = Tween(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _cursorAnimationController,
      ),
    );

    _cursorAnimationController
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _cursorAnimationController.repeat(reverse: true);
        }
      })
      ..forward();

    _mainNodes.forEach((key, value) {
      value.addListener(() {
        setState(() {});
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainNodes[_currentKeyboard]?.requestFocus();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    for (var element in _mainNodes.values) {
      element.dispose();
    }
    _cursorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mainNodes[_currentKeyboard]?.unfocus();
          _mainNodes[_currentKeyboard]?.requestFocus();
        });
        setState(() {});
      },
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Offstage(
            child: Column(
              children: _mainNodes
                  .map((key, value) {
                    return MapEntry(
                      key,
                      TextField(
                        focusNode: value,
                        controller: _mainController,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: key,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]'),
                          ),
                          LengthLimitingTextInputFormatter(
                            widget.characters.length,
                          ),
                        ],
                        onChanged: (String value) {
                          if (value.length > _currentIndex) {
                            var result = widget.characters[_currentIndex]
                                .format(value[_currentIndex]);
                            if (value[_currentIndex] != result) {
                              value = value.replaceRange(
                                _currentIndex,
                                _currentIndex + 1,
                                result,
                              );
                              _mainController.value =
                                  _mainController.value.copyWith(
                                text: value,
                                selection: TextSelection.collapsed(
                                  offset: value.length,
                                ),
                              );
                            }
                          }
                          _onChanged(value);
                        },
                      ),
                    );
                  })
                  .values
                  .toList(),
            ),
          ),
          if (widget.buildCustomInput != null) ...[
            widget.buildCustomInput!.call(
              context,
              widget.characters
                  .asMap()
                  .map(
                    (key, value) => MapEntry(key, _createCharacter(key)),
                  )
                  .values
                  .toList(),
            ),
          ] else ...[
            for (var i = 0; i < widget.characters.length; i++) ...[
              _createCharacter(i),
              if (i < widget.characters.length - 1 && widget.spacing > 0) ...[
                SizedBox(
                  height: widget.spacing,
                  width: widget.spacing,
                ),
              ]
            ],
          ],
        ],
      ),
    );
  }

  void _onChanged(String value) {
    widget.onChanged.call(value, value.length == widget.characters.length);
    setState(() {
      _currentValue = value;
    });

    var nextIndex = min(_currentValue.length, widget.characters.length - 1);
    if (_currentIndex != nextIndex) {
      setState(() {
        _currentIndex = nextIndex;
      });
    }

    var nextKeyboard = widget.characters[_currentIndex].keyboardType;
    if (_currentKeyboard != nextKeyboard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mainNodes[nextKeyboard]?.requestFocus();
      });
      setState(() {
        _currentKeyboard = nextKeyboard;
      });
    }
  }

  Widget _createCharacter(int index) {
    var char = widget.characters[index];
    if (char.readOnly) {
      return Text(
        char.hint,
        style: widget.textStyle,
      );
    }
    Widget input = TextField(
      textCapitalization: TextCapitalization.characters,
      decoration: widget.inputDecoration?.copyWith(
        label: _createLabel(index),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      textAlign: widget.textAlign,
      style: widget.textStyle,
      readOnly: true,
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mainNodes[_currentKeyboard]?.unfocus();
          _mainNodes[_currentKeyboard]?.requestFocus();
        });
        setState(() {});
      },
      controller: TextEditingController.fromValue(
        TextEditingValue(text: _getCurrentInputValue(index)),
      ),
    );
    if (widget.buildDecoration != null) {
      return widget.buildDecoration!.call(context, input);
    }
    return input;
  }

  String _getCurrentInputValue(index) {
    if (_currentValue.length > index) {
      return _currentValue[index];
    }
    return '';
  }

  bool _hasFocus() {
    return _mainNodes.values.any((element) => element.hasFocus);
  }

  Widget _createLabel(int index) {
    if (index < _currentValue.length) {
      return const SizedBox.shrink();
    }
    if (index == _currentValue.length && _hasFocus()) {
      return AnimatedBuilder(
        animation: _cursorAnimation,
        builder: (context, _) {
          return Opacity(
            opacity: _cursorAnimation.value,
            child: Container(
              alignment: _getAlignment(widget.cursorTextAlign),
              child: Text(
                '|',
                style: widget.textStyle,
                textAlign: widget.cursorTextAlign,
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        alignment: _getAlignment(widget.textAlign),
        child: Text(
          widget.characters[index].hint,
          style: widget.inputDecoration?.hintStyle ?? widget.textStyle,
          textAlign: widget.textAlign,
        ),
      );
    }
  }

  Alignment _getAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
      case TextAlign.justify:
        return Alignment.center;
    }
  }
}
