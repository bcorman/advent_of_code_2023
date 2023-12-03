import 'dart:async';

import 'dart:io';
import 'dart:math';

typedef GameData = ({int? id, int redSum, int greenSum, int blueSum});

GameData processGame(String game) {
  int maxRed = 0;
  int maxBlue = 0;
  int maxGreen = 0;
  RegExp idPattern = RegExp('(?<id>(?<=Game )\\d+(?=:))');
  final idMatch = idPattern.firstMatch(game);
  if (idMatch == null) {
    throw ArgumentError('No ID found in $game');
  }

  final id = int.parse(idMatch.namedGroup('id')!);

  RegExp colorPattern =
      RegExp('(?<red>\\d+ red)|(?<blue>\\d+ blue)|(?<green>\\d+ green)');

  final colorMatches = colorPattern.allMatches(game);
  if (colorMatches.isEmpty) {
    throw ArgumentError('No color found in $game');
  }
  colorMatches.forEach((colorMatch) {
    String? redValue = colorMatch.namedGroup('red');
    String? blueValue = colorMatch.namedGroup('blue');
    String? greenValue = colorMatch.namedGroup('green');
    if (redValue != null && redValue.isNotEmpty) {
      maxRed = max(maxRed, sumColor(redValue));
    }
    if (blueValue != null && blueValue.isNotEmpty) {
      maxBlue = max(maxBlue, sumColor(blueValue));
    }
    if (greenValue != null && greenValue.isNotEmpty) {
      maxGreen = max(maxGreen, sumColor(greenValue));
    }
  });

  return (id: id, redSum: maxRed, blueSum: maxBlue, greenSum: maxGreen);
}

int sumColor(String result) {
  final intPattern = RegExp('(?<int>\\d+)');
  final number = intPattern.firstMatch(result)?.namedGroup('int');
  if (number == null) {
    throw ArgumentError('No integer found in $result');
  }
  return int.parse(number);
}

Future<void> main() async {
  final contents = await File('./src/day2/cubes.txt').readAsString();
  List<String> games = contents.split('\n');
  int sumOfGameIds = 0;
  int maxAllowedRed = 12;
  int maxAllowedGreen = 13;
  int maxAllowedBlue = 14;

  for (var game in games) {
    if (game.isEmpty) {
      break;
    }
    GameData processedGame = processGame(game);
    print(game);
    if (processedGame.redSum <= maxAllowedRed &&
        processedGame.greenSum <= maxAllowedGreen &&
        processedGame.blueSum <= maxAllowedBlue) {
      print(processedGame);
      sumOfGameIds += processedGame.id!;
    }
  }
  print(sumOfGameIds);
}
