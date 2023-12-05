import 'dart:io';
import 'dart:math';

Future<void> main() async {
  final contents = await File('./src/day5/input.txt').readAsString();
  final splitContents =
      contents.trim().split(RegExp(r'^\s*$', multiLine: true));

  final seeds = splitContents.first
      .substring(splitContents.first.indexOf(':') + 1)
      .trim()
      .split(' ')
      .map((e) => int.parse(e));

  Map<String, GardenMap> maps = Map.fromIterable(
      splitContents.skip(1).map((rawData) => GardenMap(rawData)),
      key: (m) => m.type,
      value: (m) => m);
  List<int> locations = [];
  for (var seed in seeds) {
    final location = maps.values.fold(seed, (previousValue, gardenMap) {
      final destination = gardenMap.findDestination(previousValue);
      print(gardenMap.type);
      print('$previousValue => $destination');
      return destination;
    });
    locations.add(location);
  }
  print(locations.reduce(min));
}

typedef MapRange = ({int low, int high});
typedef SourceToDestinationMap = ({MapRange source, MapRange destination});

class GardenMap {
  String type;
  Set<SourceToDestinationMap> mapSet;
  GardenMap._({
    required this.type,
    required this.mapSet,
  });

  int findDestination(int source) {
    try {
      final SourceToDestinationMap map = mapSet.singleWhere(
        (m) => source >= m.source.low && source <= m.source.high,
      );
      print(
          'Destination found in $map. Destination: ${source + (map.destination.low - map.source.low)}');
      return source + (map.destination.low - map.source.low);
    } catch (_) {
      print('No mapped destination found, returning source');
      return source;
    }
  }

  factory GardenMap(String rawMapData) {
    final type = rawMapData.substring(0, rawMapData.indexOf(' map:')).trim();

    final data =
        rawMapData.split('\n').where((line) => line.contains(RegExp(r'\d+')));

    final Set<SourceToDestinationMap> mapSet = {};
    for (var line in data) {
      final numbers = line.split(' ').map((e) => int.parse(e)).toList();
      final ({int low, int high}) sourceRange =
          (low: numbers[1], high: numbers[1] + numbers[2] - 1);
      final ({int low, int high}) destinationRange =
          (low: numbers[0], high: numbers[0] + numbers[2] - 1);

      // If the range falls within an existing range, ignore it.
      bool rangeIsRedundant = mapSet.every((map) =>
          (map.source.low <= sourceRange.low &&
              map.source.high >= sourceRange.high &&
              map.destination.low <= destinationRange.low &&
              map.destination.high >= destinationRange.high));
      if (mapSet.isEmpty || !rangeIsRedundant) {
        mapSet.add((source: sourceRange, destination: destinationRange));
      }
    }

    return GardenMap._(
      type: type,
      mapSet: mapSet,
    );
  }

  @override
  String toString() {
    return '''
type: $type
map: $mapSet
''';
  }
}
