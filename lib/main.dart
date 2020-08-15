import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:waveprogressbar_flutter/waveprogressbar_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 60;
  int _flowTime = 60;
  int _breakTime = 20;

  bool _isPlaying;

  double doubleConverter(double d) => d / _flowTime;

  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPlaying = false;
  }

  void _timerHandler() {
    if (_isPlaying == true) {
      setState(() {
        _isPlaying = false;
      });
      _pauseTimer();
    } else {
      _startTimer(_counter);
    }
  }

  void _startTimer(int timerDuration) {
    // _counter = _flowTime;
    setState(() {
      _isPlaying = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
          _isPlaying = false;
        }
      });
    });
  }

  void _pauseTimer() {
    print(_counter);
    _timer.cancel();
  }

  String formatTime(double time) {
    Duration duration = Duration(seconds: time.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 350,
                  width: 350,
                  child: LiquidCircularProgressIndicator(
                    value: doubleConverter((_counter.toDouble()) + 1.5),
                    valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    direction: Axis.vertical,
                  ),
                ),
                Container(
                  height: 350,
                  width: 350,
                  child: LiquidCircularProgressIndicator(
                    value: doubleConverter(_counter.toDouble()),
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    direction: Axis.vertical,
                  ),
                ),
              ],
            ),
            Text(
              formatTime(_counter.toDouble()),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _timerHandler,
        tooltip: _isPlaying ? 'pause' : 'play',
        child: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
