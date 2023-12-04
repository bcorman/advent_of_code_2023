import 'dart:async';
import 'dart:io';

typedef PartData = ({int value, int startIndex, int endIndex, int rowNumber});

RegExp gearPattern = RegExp(r'\*');

int findStartIndex(int index, String lineSegment) {
  if (index == 0) {
    return index;
  }
  if (!lineSegment[index].contains(RegExp(r'\d'))) {
    throw ArgumentError(
        'findStartIndex called with index $index that is not a number: ${lineSegment[index]}');
  }
  for (var i = index; i > 0; i--) {
    if (lineSegment[i].contains(RegExp(r'\d')) &&
        !lineSegment[i - 1].contains(RegExp(r'\d'))) {
      return i;
    }
  }
  return index;
}

PartData? findPart(int startIndex, String lineSegment, int rowNumber) {
  if (lineSegment.isEmpty) {
    throw ArgumentError('findPart called with empty lineSegment');
  }
  if (!lineSegment[startIndex].contains(RegExp(r'\d'))) {
    throw ArgumentError(
        'findPart called with startIndex that is not the beginning of a part');
  }
  String value = '';
  for (var i = startIndex; i < lineSegment.length; i++) {
    bool isNumber = lineSegment[i].contains(RegExp(r'\d'));

    if (isNumber) {
      value += lineSegment[i];
    } else {
      if (value.isEmpty) {
        throw ArgumentError(
            'findPart failed to produce a value with startIndex: $startIndex and line: \n $lineSegment');
      }
      return (
        value: int.parse(value),
        startIndex: startIndex,
        endIndex: startIndex + value.length - 1,
        rowNumber: rowNumber
      );
    }
  }
  return null;
}

enum SearchArea { AboveOrBelow, Before, After }

(int, int) getBounds(int gearIndex, String line, SearchArea searchArea) {
  int indexBefore = gearIndex > 0 ? gearIndex - 1 : 0;
  int indexAfter =
      gearIndex < line.length - 1 ? gearIndex + 1 : line.length - 1;
  if (searchArea == SearchArea.AboveOrBelow) {
    return (indexBefore, indexAfter);
  }
  if (searchArea == SearchArea.Before) {
    return (indexBefore, indexBefore);
  }
  if (searchArea == SearchArea.After) {
    return (indexAfter, indexAfter);
  }
  throw UnimplementedError('Unable to search $searchArea');
}

Set<PartData> search(
    int gearIndex, String line, SearchArea searchArea, int rowNumber) {
  Set<PartData> parts = {};
  if (line.isEmpty) {
    if (searchArea == SearchArea.Before || searchArea == SearchArea.After) {
      throw ArgumentError(
          'search called with invalid argument: gearIndex: $gearIndex, searchArea: $searchArea, line: $line');
    }
    return parts;
  }
  final (startIndex, endIndex) = getBounds(gearIndex, line, searchArea);
  int i = startIndex;
  while (i <= endIndex) {
    bool isNumber = line[i].contains(RegExp(r'\d'));

    if (isNumber) {
      final partStartIndex = findStartIndex(i, line);
      final part = findPart(partStartIndex, line, rowNumber);

      if (part != null) {
        parts.add(part);
        if (searchArea == SearchArea.AboveOrBelow &&
            part.endIndex == gearIndex - 1) {
          i = part.endIndex + 1;
        }
      }
    }
    i++;
  }
  return parts;
}

Future<void> main() async {
  int sumOfGearRatios = 0;
  final contents = await File('./src/day3/input.txt').readAsString();
  List<String> engineChart = contents.split('\n');

  for (var lineNumber = 0; lineNumber < engineChart.length; lineNumber++) {
    String line = engineChart[lineNumber];
    final List<int> gearLocations =
        gearPattern.allMatches(line).map((e) => e.start).toList();

    for (var gearIndex in gearLocations) {
      final Set<PartData> parts = {};

      // Search Above
      if (lineNumber > 0) {
        parts.addAll(search(gearIndex, engineChart[lineNumber - 1],
            SearchArea.AboveOrBelow, lineNumber - 1));
      }
      // Search Below
      if (lineNumber < engineChart.length - 1) {
        parts.addAll(search(gearIndex, engineChart[lineNumber + 1],
            SearchArea.AboveOrBelow, lineNumber + 1));
      }
      // Search Before
      if (gearIndex > 0) {
        parts.addAll(search(gearIndex, line, SearchArea.Before, lineNumber));
      }
      // Search After
      if (gearIndex < line.length - 1) {
        parts.addAll(search(gearIndex, line, SearchArea.After, lineNumber));
      }

      if (parts.length == 2) {
        print('eligible parts: ${parts.map((e) => e.value)}');
        int gearRatio = parts
            .map((e) => e.value)
            .reduce((value, element) => value * element);
        print('gearRatio of $parts is $gearRatio');
        sumOfGearRatios += gearRatio;

        print(sumOfGearRatios);
      } else if (parts.isNotEmpty && parts.length != 2) {
        print('ineligible parts: ${parts.map((e) => e.value)}');
      }
    }
  }
  print(sumOfGearRatios);
}
