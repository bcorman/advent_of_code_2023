import 'dart:io';

Future<void> main() async {
  final contents = await File('./src/day4/input.txt').readAsString();
  List<String> cards = contents.trim().split('\n');
  int sumOfPoints = 0;
  cards.forEach((cardText) {
    final card = Card(cardText);
    sumOfPoints += card.pointValue;
  });
  print(sumOfPoints);
}

class Card {
  List<String> winningNumbers;
  List<String> playNumbers;
  int get pointValue {
    int points = 0;
    this.matches;
    matches.forEach((match) {
      if (points == 0) {
        points = 1;
      } else {
        points *= 2;
      }
    });
    return points;
  }

  List<String> get matches {
    return playNumbers
        .where((number) => winningNumbers.contains(number))
        .toList();
  }

  Card._(this.winningNumbers, this.playNumbers);

  factory Card(String card) {
    if (card.isEmpty) {
      throw ArgumentError('Card created with empty card text');
    }
    final numberPattern = RegExp(r'\d+');
    final winningSection =
        card.substring(0, card.indexOf('|')).substring(card.indexOf(':') + 1);
    final winningNumbers =
        numberPattern.allMatches(winningSection).map((e) => e[0]!).toList();
    final playSection = card.substring(card.indexOf('|') + 1);
    final playNumbers =
        numberPattern.allMatches(playSection).map((e) => e[0]!).toList();
    return new Card._(winningNumbers, playNumbers);
  }

  @override
  String toString() {
    return '''Card(
      winningNumbers: $winningNumbers
      playNumbers: $playNumbers
      matches: $matches
      points: $pointValue
    )''';
  }
}
