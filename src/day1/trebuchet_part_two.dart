import 'dart:async';

import 'dart:io';

Future<void> main() async {
  int sum = 0;
  final numbers = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
  };
  RegExp pattern = RegExp('(?<number>${numbers.keys.map(
        (e) => '(?=$e)',
      ).join('|')})');
  RegExp subPattern = RegExp('(?<number>${numbers.keys.join('|')})');
  final contents = await File('./src/day1/trebuchet_input.txt').readAsString();

  List<String> lines = contents.split('\n');

  for (final line in lines) {
    if (line.isEmpty) {
      break;
    }
    (String, {int? index}) firstDigit = ('', index: null);
    (String, {int? index}) firstNum = ('', index: null);
    (String, {int? index}) secondDigit = ('', index: null);
    (String, {int? index}) secondNum = ('', index: null);

    final potentialMatches = pattern.allMatches(line).map((match) =>
        (subPattern.firstMatch(line.substring(match.start)), match.start));

    if (potentialMatches.isNotEmpty) {
      firstNum = (
        potentialMatches.first.$1!.namedGroup('number')!,
        index: potentialMatches.first.$2
      );
      secondNum = (
        potentialMatches.last.$1!.namedGroup('number')!,
        index: potentialMatches.last.$2
      );
    }

    for (var i = 0; i < line.length; i++) {
      final lastIndex = line.length - 1 - i;
      if (firstDigit.$1.isEmpty) {
        if (line[i].contains(RegExp('[0-9]'))) {
          firstDigit = (line[i], index: i);
        }
      }

      if (secondDigit.$1.isEmpty) {
        if (line[lastIndex].contains(RegExp('[0-9]'))) {
          secondDigit = (line[lastIndex], index: lastIndex);
        }
      }
      if (firstDigit.$1.isNotEmpty && secondDigit.$1.isNotEmpty) {
        break;
      }
    }

    final firstValue = firstNum.$1.isEmpty
        ? firstDigit.$1
        : firstDigit.index! < firstNum.index!
            ? firstDigit.$1
            : numbers[firstNum.$1].toString();
    final secondValue = secondNum.$1.isEmpty
        ? secondDigit.$1
        : secondDigit.index! > secondNum.index!
            ? secondDigit.$1
            : numbers[secondNum.$1].toString();

    final value = int.parse((firstValue + secondValue));

    sum += value;
  }
  print('the sum is $sum');
}
