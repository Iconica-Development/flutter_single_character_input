<!-- [![pub package](https://img.shields.io/pub/v/[PACKAGE NAME ON PUB].svg)](https://github.com/Iconica-Development) [![Build status](URL TO REPO)](URL TO GITHUB ACTIONS) -->

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)

Custom widget that allows for an inputfield spilt over multiple fields
Ported from the appshell.

## Setup

To use this package, add `flutter_single_character_input` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

```dart
 flutter_single_character_input:
    git:
      url: https://github.com/Iconica-Development/flutter_single_character_input.git
      ref: master
```

## How to use

```dart
 SingleCharacterInput(
          characters: [
            InputCharacter(
              hint: '1',
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              formatter: (value) {
                if (RegExp('[0-9]').hasMatch(value)) {
                  return value;
                }
                return '';
              },
            ),
            InputCharacter(
              hint: 'B',
              keyboardType: TextInputType.name,
              formatter: (value) {
                if (RegExp('[A-Za-z]').hasMatch(value)) {
                  return value.toUpperCase();
                }
                return '';
              },
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
          onChanged: (value, finished) {},
        ),
```

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_single_character_input) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](./CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_single_character_input/pulls).

## Author

This `flutter-single-character-input` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>
