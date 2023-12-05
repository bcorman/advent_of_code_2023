import 'dart:io';

Future<void> main() async {
  final contents = await File('./src/day4/input.txt').readAsString();
  Map<int, Card> cards = Map.fromIterable(
      contents.trim().split('\n').map((cardData) => Card(cardData)),
      key: (c) => c.cardNumber,
      value: (c) => c);
  int totalCards = 0;
  for (Card card in cards.values) {
    int copiesOfCurrentCard = card.copies;
    for (var cardWon in card.cardsWon) {
      if (cards.containsKey(cardWon)) {
        cards[cardWon]!.copies += copiesOfCurrentCard;
      }
    }
    totalCards += card.copies;
  }
  print(totalCards);
}

class Card {
  int cardNumber;
  int copies = 1;
  List<String> winningNumbers;
  List<String> playNumbers;

  List<String> get matches {
    return playNumbers
        .where((number) => winningNumbers.contains(number))
        .toList();
  }

  int get pointValue {
    int points = 0;
    matches.forEach((match) {
      if (points == 0) {
        points = 1;
      } else {
        points *= 2;
      }
    });
    return points;
  }

  List<int> get cardsWon {
    final winnings = <int>[];
    for (var i = 1; i <= numberOfMatches; i++) {
      winnings.add(cardNumber + i);
    }
    return winnings;
  }

  int get numberOfMatches => matches.length;

  Card._(this.cardNumber, this.winningNumbers, this.playNumbers);

  factory Card(String card) {
    if (card.isEmpty) {
      throw ArgumentError('Card created with empty card text');
    }
    final numberPattern = RegExp(r'\d+');
    final cardNumber =
        numberPattern.firstMatch(card.substring(0, card.indexOf(':')))![0];
    final winningSection =
        card.substring(0, card.indexOf('|')).substring(card.indexOf(':') + 1);
    final winningNumbers =
        numberPattern.allMatches(winningSection).map((e) => e[0]!).toList();
    final playSection = card.substring(card.indexOf('|') + 1);
    final playNumbers =
        numberPattern.allMatches(playSection).map((e) => e[0]!).toList();
    return new Card._(int.parse(cardNumber!), winningNumbers, playNumbers);
  }

  @override
  String toString() {
    return '''Card(
      copies: $copies
      cardNumber: $cardNumber
      winningNumbers: $winningNumbers
      playNumbers: $playNumbers
      matches: $matches
      points: $pointValue
    )''';
  }
}
