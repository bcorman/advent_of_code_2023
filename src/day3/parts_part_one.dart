import 'dart:async';

import 'dart:io';

typedef PartData = ({
  int value,
  int numberOfDigits,
  int startIndex,
  int endIndex,
});

RegExp symbolPattern = RegExp(r'[^\d.\s]');

bool searchSegment(PartData part, String line) {
  if (line.isEmpty) {
    return false;
  }
  int startIndex = part.startIndex > 0 ? part.startIndex - 1 : 0;
  int endIndex =
      part.endIndex < line.length - 1 ? part.endIndex + 1 : line.length - 1;

  final segment = line.substring(startIndex, endIndex + 1);

  if (segment.contains(symbolPattern)) {
    return true;
  }
  return false;
}

Future<void> main() async {
  int sum = 0;
  final contents = await File('./src/day3/input.txt').readAsString();
  List<String> engineChart = contents.split('\n');

  for (var lineNumber = 0; lineNumber < engineChart.length; lineNumber++) {
    final line = engineChart[lineNumber];

    int i = 0;
    String value = '';
    int? startIndex;

    while (i < line.length) {
      bool containsDigit = line[i].contains(RegExp(r'\d'));
      if (line[i] == '.' && value.isEmpty) {
        i++;
        continue;
      }
      if (containsDigit) {
        if (value.isEmpty) {
          startIndex = i;
        }
        value += line[i];
      }
      if ((i == line.length - 1 || !containsDigit) &&
          (value.isNotEmpty && startIndex != null)) {
        PartData partData = (
          value: int.parse(value),
          numberOfDigits: value.length,
          startIndex: startIndex,
          endIndex: startIndex + value.length - 1
        );
        bool hasSymbolAbove = lineNumber > 0
            ? searchSegment(partData, engineChart[lineNumber - 1])
            : false;
        bool hasSymbolBelow = lineNumber < engineChart.length - 1
            ? searchSegment(partData, engineChart[lineNumber + 1])
            : false;
        bool hasSymbolBefore = partData.startIndex > 0
            ? line[partData.startIndex - 1].contains(symbolPattern)
            : false;
        bool hasSymbolAfter = partData.endIndex < line.length - 1
            ? line[partData.endIndex + 1].contains(symbolPattern)
            : false;
        if (hasSymbolAbove ||
            hasSymbolBelow ||
            hasSymbolBefore ||
            hasSymbolAfter) {
          sum += partData.value;
        }
        value = '';
        startIndex = null;
      }
      i++;
    }
  }
  print(sum);
}
