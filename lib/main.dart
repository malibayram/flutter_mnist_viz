import 'dart:math';

import 'package:flutter/material.dart';

import 'cizim_tahtasi.dart';
import 'kare_kutu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,5
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Flutter Demo Home Page"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✔✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // random matrix of 784 x 25 for first layers weights
  final _firstLayerWeights = List.generate(
    784,
    (i) => List.generate(
      20,
      (j) => Random().nextDouble() * (Random().nextBool() ? 1 : -1),
    ),
  );

  final _firstLayerOutput = List.generate(20, (i) => 0.0);

  final _secondLayerWeights = List.generate(
    20,
    (i) => List.generate(
      25,
      (j) => Random().nextDouble() * (Random().nextBool() ? 1 : -1),
    ),
  );

  final _secondLayerOutput = List.generate(25, (i) => 0.0);

  final _lastLayerWeights = List.generate(
    25,
    (i) => List.generate(
      10,
      (j) => Random().nextDouble() * (Random().nextBool() ? 1 : -1),
    ),
  );

  final _lastLayerOutput = List.generate(10, (i) => 0.0);

  void _calculateOutput(List<double> imagePixels) {
    // if all pixels are white, call _clear method
    if (imagePixels.every((e) => e == 0)) {
      _clear();
      return;
    }

    for (var i = 0; i < _firstLayerOutput.length; i++) {
      _firstLayerOutput[i] = 0;
      for (var j = 0; j < imagePixels.length; j++) {
        _firstLayerOutput[i] += imagePixels[j] * _firstLayerWeights[j][i];
      }
      _firstLayerOutput[i] = 1 / (1 + exp(-_firstLayerOutput[i]));
    }

    for (var i = 0; i < _secondLayerOutput.length; i++) {
      _secondLayerOutput[i] = 0;
      for (var j = 0; j < _firstLayerOutput.length; j++) {
        _secondLayerOutput[i] +=
            _firstLayerOutput[j] * _secondLayerWeights[j][i];
      }
      _secondLayerOutput[i] = 1 / (1 + exp(-_secondLayerOutput[i]));
    }

    // calculate output layer using softmax
    var sum = 0.0;
    for (var i = 0; i < _lastLayerOutput.length; i++) {
      _lastLayerOutput[i] = 0;
      for (var j = 0; j < _secondLayerOutput.length; j++) {
        _lastLayerOutput[i] += _secondLayerOutput[j] * _lastLayerWeights[j][i];
      }
      sum += exp(_lastLayerOutput[i]);
    }

    for (var i = 0; i < _lastLayerOutput.length; i++) {
      _lastLayerOutput[i] = exp(_lastLayerOutput[i]) / sum;
    }

    setState(() {});
  }

  void _clear() {
    for (var i = 0; i < _firstLayerOutput.length; i++) {
      _firstLayerOutput[i] = 0;
    }

    for (var i = 0; i < _secondLayerOutput.length; i++) {
      _secondLayerOutput[i] = 0;
    }

    for (var i = 0; i < _lastLayerOutput.length; i++) {
      _lastLayerOutput[i] = 0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                for (int i = 0; i < _lastLayerOutput.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Text(
                          "$i",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        KareKutu(
                          percentage: _lastLayerOutput[i],
                          width: MediaQuery.of(context).size.width /
                                  _lastLayerOutput.length -
                              4,
                        ),
                        Text(
                          _lastLayerOutput[i].toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 200 / _lastLayerOutput.length,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final output in _secondLayerOutput)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        KareKutu(
                          percentage: output,
                          width: MediaQuery.of(context).size.width /
                                  _secondLayerOutput.length -
                              4,
                        ),
                        Text(
                          output.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 200 / _secondLayerOutput.length,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final output in _firstLayerOutput)
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        KareKutu(
                          percentage: output,
                          width: MediaQuery.of(context).size.width /
                                  _firstLayerOutput.length -
                              4,
                        ),
                        Text(
                          output.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 200 / _firstLayerOutput.length),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 360,
              width: 360,
              child: CizimTahtasi(onImageUpdated: _calculateOutput),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
