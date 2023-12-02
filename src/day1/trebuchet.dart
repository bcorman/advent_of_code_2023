import 'dart:async';

import 'dart:io';

Future<void> main() async {
  int sum = 0;
  final contents = await File('./src/day1/trebuchet_input.txt').readAsString();

  List<String> lines = contents.split('\n');

  for (final line in lines) {
    String firstDigit = '';
    String secondDigit = '';
    if (line.isEmpty) {
      break;
    }

    for (var i = 0; i < line.length; i++) {
      if (firstDigit.isEmpty) {
        if (line[i].contains(RegExp('[0-9]'))) {
          firstDigit = line[i];
        }
      }
      if (secondDigit.isEmpty) {
        if (line[line.length - 1 - i].contains(RegExp('[0-9]'))) {
          secondDigit = line[line.length - 1 - i];
        }
      }
      if (firstDigit.isNotEmpty && secondDigit.isNotEmpty) {
        break;
      }
    }

    final value = int.parse((firstDigit + secondDigit));

    sum += value;
  }
  print('the sum is $sum');
}
