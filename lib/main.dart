import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.black, body: Center(child: LightsOutGame())),
    );
  }
}

class LightsOutGame extends StatefulWidget {
  LightsOutGame({Key? key}) : super(key: key);

  @override
  _LightsOutGame createState() => _LightsOutGame();
}

class _LightsOutGame extends State<LightsOutGame> {
  // Number of possible states for each cell. For the standard lights out game,
  // it is 2 (on/off). Changing states is `(currentState + 1) % numValues`.
  final int numValues = 2;
  final int gridSize = 5;
  late List<List<int>> gridValues;

  @override
  void initState() {
    super.initState();
    gridValues = randomGridValues(gridSize, numValues);
  }

  static List<List<int>> randomGridValues(int gridSize, int numValues) {
    var gridValues =
        new List.generate(gridSize, (_) => List.filled(gridSize, 0));

    var rand = Random();
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        gridValues[i][j] = rand.nextInt(numValues);
      }
    }
    return gridValues;
  }

  void _clickCell(rowIndex, colIndex) {
    setState(() {
      // print("Detected click at [$rowIndex,$colIndex]");

      for (int i = rowIndex - 1; i < rowIndex + 2; i++) {
        for (int j = colIndex - 1; j < colIndex + 2; j++) {
          if ((i < 0 || j < 0) || (i >= gridSize || j >= gridSize)) {
            // print("skipping at [$i,$j]");
            continue;
          }
          // print("toggling at [$i,$j]");
          gridValues[i][j] = (gridValues[i][j] + 1) % numValues;
        }
      }
    });
  }

  Container buildCell(int value, int rowIndex, int colIndex) {
    double minDimension = min(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    double cellDimensions = minDimension / gridSize * 0.9;

    Widget content = Text(
      "$value",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 72,
      ),
    );
    if (numValues == 2) {
      content = Container(
          decoration: BoxDecoration(
              color: (value == 0) ? Colors.black54 : Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.all(Radius.zero)),
          width: cellDimensions,
          height: cellDimensions,
          child: AspectRatio(
            aspectRatio: 1,
            child: Text(
              "$value",
              style: TextStyle(
                color: (value == 0) ? Colors.black54 : Colors.white,
                fontSize: 72,
              ),
            ),
          ));
    }

    return Container(
        child: GestureDetector(
            onTap: () => _clickCell(rowIndex, colIndex), child: content));
  }

  Row buildRow(List<int> rowValues, int rowIndex) {
    // if (numValues == 2) {
    //   return Row(
    //       children: rowValues
    //           .map<Container>((value) => Container(
    //               decoration: BoxDecoration(
    //                   color: (value == 0) ? Colors.black : Colors.white)))
    //           .toList());
    // }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowValues.asMap().entries.map<Container>((columnEntry) {
        int colIndex = columnEntry.key;
        int value = columnEntry.value;
        return Container(child: buildCell(value, rowIndex, colIndex));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: this.gridValues.asMap().entries.map<Row>((rowEntry) {
              int rowIndex = rowEntry.key;
              List<int> rowValues = rowEntry.value;
              return buildRow(rowValues, rowIndex);
            }).toList()));
  }
}
