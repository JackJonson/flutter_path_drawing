import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> paths = const <String>[
    '''M 15 15.5 A 0.5 1.5 0 1 1  14,15.5 A 0.5 1.5 0 1 1  15 15.5 z''',
    'M100,200 L3,4',
    'M100,200 l3,4',
    'M100,200 H3',
    'M100,200 h3',
    'M100,200 V3',
    'M100,200 v3',
    'M100,200 C3,4,5,6,7,8',
    'M100,200 c3,4,5,6,7,8',
    'M100,200 S3,4,5,6',
    'M100,200 s3,4,5,6',
    'M100,200 Q3,4,5,6',
    'M100,200 q3,4,5,6',
    'M100,200 T3,4',
    'M100,200 t3,4',
    'M100,200 A3,4,5,0,0,6,7',
    'M100,200 A3,4,5,1,0,6,7',
    'M100,200 A3,4,5,0,1,6,7',
    'M100,200 A3,4,5,1,1,6,7',
    'M100,200 a3,4,5,0,0,6,7',
    'M100,200 a3,4,5,0,1,6,7',
    'M100,200 a3,4,5,1,0,6,7',
    'M100,200 a3,4,5,1,1,6,7',
    'M100,200 a3,4,5,006,7',
    'M100,200 a3,4,5,016,7',
    'M100,200 a3,4,5,106,7',
    'M100,200 a3,4,5,116,7',
    '''M19.0281,19.40466 20.7195,19.40466 20.7195,15.71439 24.11486,15.71439 24.11486,14.36762 20.7195,14.36762
20.7195,11.68641 24.74134,11.68641 24.74134,10.34618 19.0281,10.34618 	z''',
    'M100,200 a0,4,5,0,0,10,0 a4,0,5,0,0,0,10 a0,0,5,0,0,-10,0 z',
    'M.1 .2 L.3 .4 .5 .6',
    'M1,1h2,3',
    'M1,1H2,3',
    'M1,1v2,3',
    'M1,1V2,3',
    'M1,1c2,3 4,5 6,7 8,9 10,11 12,13',
    'M1,1C2,3 4,5 6,7 8,9 10,11 12,13',
    'M1,1s2,3 4,5 6,7 8,9',
    'M1,1S2,3 4,5 6,7 8,9',
    'M1,1q2,3 4,5 6,7 8,9',
    'M1,1Q2,3 4,5 6,7 8,9',
    'M1,1t2,3 4,5',
    'M1,1T2,3 4,5',
    'M1,1a2,3,4,0,0,5,6 7,8,9,0,0,10,11',
    'M1,1A2,3,4,0,0,5,6 7,8,9,0,0,10,11',
  ];

  int index = 0;

  String get currPath => paths[index];

  void nextPath() {
    setState(() => index = index >= paths.length - 1 ? 0 : index + 1);
  }

  void prevPath() {
    setState(() => index = index == 0 ? paths.length - 1 : index - 1);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CustomPaint(painter: new PathTestPainter(currPath))
            ],
          ),
        ),
        floatingActionButton: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FloatingActionButton(
                child: const Icon(Icons.navigate_before),
                backgroundColor: Colors.blueGrey,
                onPressed: prevPath,
              ),
              new Container(
                  child: new Text(index.toString()),
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0)),
              new FloatingActionButton(
                child: const Icon(Icons.navigate_next),
                backgroundColor: Colors.blueGrey,
                onPressed: nextPath,
              )
            ]));
  }
}

class PathTestPainter extends CustomPainter {
  PathTestPainter(String path) : p = parseSvgPathData(path);

  final Path p;
  final Path p2 = new Path()
    ..moveTo(10.0, 10.0)
    ..lineTo(100.0, 100.0)
    //..lineTo(125.0, 20.0)
    ..quadraticBezierTo(125.0, 20.0, 200.0, 100.0)
    ..addRect(new Rect.fromLTWH(0.0, 0.0, 50.0, 50.0));
  final Path p3 = new Path()
    ..addRect(new Rect.fromLTWH(20.0, 20.0, 50.0, 50.0));
  final Paint black = new Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;
  final Paint red = new Paint()
    ..color = Colors.red
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke;

  @override
  bool shouldRepaint(PathTestPainter old) => true;

  static Float64List matrix(
      double a, double b, double c, double d, double e, double f) {
    return new Matrix4(
            a, b, 0.0, 0.0, c, d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, e, f, 0.0, 1.0)
        .storage;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(p, black);
    // canvas.drawPath(p2, black);
    // canvas.translate(0.0, -100.0);
    // canvas.drawPath(
    //     dashPath(p2,
    //         dashArray: new CircularIntervalList<double>(
    //             <double>[5.0, 10.0, 15.0, 15.0]),
    //         dashOffset: new DashOffset.percentage(.05)),
    //     red);
    // canvas
    //   ..scale(5.0, 5.0)
    //   ..translate(-50.0, -35.0);
    // canvas.drawPath(p3, red);
    // canvas.drawPath(p2, red);
    // canvas.drawPath(Path.combine(PathOperation.intersect, p2, p3), black);
  }
}
