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
  int _coffeeTime = 20;
  int _coffeeCounter = 20;

  bool _isPlaying;
  bool _isCoffeePlaying;

  Timer _timer;
  Timer _coffeeTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPlaying = false;
    _isCoffeePlaying = false;
  }

  void _timerHandler() {
    if (_isPlaying == true) {
      setState(() {
        _isPlaying = false;
      });
      _pauseTimer();
    } else {
      _startTimer(_flowTime);
    }
  }

  void _startTimer(int timerDuration) {
    _counter = timerDuration;
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

  void _coffeeTimerHandler() {
    if (_isCoffeePlaying == true) {
      setState(() {
        _isCoffeePlaying = false;
      });
      _pauseTimer();
    } else {
      _startCoffeeTimer(_coffeeTime);
    }
  }

  void _startCoffeeTimer(int timerDuration) {
    _coffeeCounter = timerDuration;
    setState(() {
      _isCoffeePlaying = true;
    });
    _coffeeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_coffeeCounter > 0) {
          _coffeeCounter--;
        } else {
          _coffeeTimer.cancel();
          _isCoffeePlaying = false;
        }
      });
    });
  }

  void _pauseCoffeeTimer() {
    print(_coffeeCounter);
    _coffeeTimer.cancel();
  }

  String formatTime(double time) {
    Duration duration = Duration(seconds: time.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  double doubleConverter(double d, int time) => d / time;

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
                  height: 250,
                  width: 250,
                  child: LiquidCircularProgressIndicator(
                    value:
                        doubleConverter((_counter.toDouble()) + 1.5, _flowTime),
                    valueColor: AlwaysStoppedAnimation(Colors.blue[300]),
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    direction: Axis.vertical,
                  ),
                ),
                Container(
                  height: 250,
                  width: 250,
                  child: LiquidCircularProgressIndicator(
                    value: doubleConverter(_counter.toDouble(), _flowTime),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                GestureDetector(
                  onTap: _coffeeTimerHandler,
                  child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: LiquidCircularProgressIndicator(
                                value: doubleConverter(
                                    (_coffeeCounter.toDouble()) + 2,
                                    _coffeeTime),
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.brown[300]),
                                backgroundColor: Colors.transparent,
                                borderColor: Colors.transparent,
                                borderWidth: 0,
                                direction: Axis.vertical,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: LiquidCircularProgressIndicator(
                                value: doubleConverter(
                                    _coffeeCounter.toDouble(), _coffeeTime),
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.brown[600]),
                                backgroundColor: Colors.transparent,
                                borderColor: Colors.transparent,
                                borderWidth: 0,
                                direction: Axis.vertical,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatTime(_coffeeCounter.toDouble()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
