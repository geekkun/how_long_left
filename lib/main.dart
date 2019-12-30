import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:math';

factors(n) {
  var factorsArr = [];
  factorsArr.add(n);
  factorsArr.add(1);
  for (var test = n - 1; test >= sqrt(n).toInt(); test--)
    if (n % test == 0) {
      factorsArr.add(test);
      factorsArr.add(n / test);
    }
  return factorsArr.sublist(factorsArr.length - 2);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wish Surf',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
//      home: MyHomePage(title: 'Wish Surf Home Page'),
      home: HomePage(title: 'How Long left?'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      new Rect.fromLTRB(0.0, 100.0, 20.0, 100.0),
      new Paint()..color = new Color(0xFF0099FF),
    );
  }

  @override
  bool shouldRepaint(Sky oldDelegate) {
    return false;
  }
}

class HomePageState extends State<HomePage> {
  final ageController = TextEditingController();
  final ageFinalController = TextEditingController();
  var sizeX = 20.0;
  var sizeY = 24.0;
  var columnLen = 10;
  var rowLen = 15;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
//    ageController.addListener(_printLatestValue);
    ageFinalController.addListener(_calculateAge);
  }

  _calculateAge() {
    var fact = factors(int.parse(ageFinalController.text));
    print(fact);
    columnLen = fact[0];
    rowLen = fact[1];
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ageController.dispose();
    ageFinalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Testing'),
        ),
        body: Center(
            child: new SingleChildScrollView(
                child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new TextField(
                            controller: ageController,
                            decoration: new InputDecoration(
                                labelText: "How old are you?"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                          ),
                          new TextField(
                            decoration: new InputDecoration(
                                labelText:
                                    "How many years are you planning to live?"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                          ),
                          new Hearts(
                            sizeX: sizeX,
                            sizeY: sizeY,
                            columnLen: columnLen,
                            rowLen: rowLen,
                            innerColor: Colors.white,
                            outColor: Colors.red,
                          )
//                    new Row(children: [
//                        for (var i = 0; i < rowLen; i++)
//                          Column(children: <Widget>[
//                            for (var i = 0; i < columnLen; i++)
//                              new CustomPaint(
//                                  size: Size(sizeX, sizeY),
//                                  foregroundPainter: new HeartPainter(
//                                    innerColor: Colors.white,
//                                    outColor: Colors.black,
//                                  )),
//                          ]),
//                      ])
                        ])))));
  }
}

class Hearts extends StatelessWidget {
  final double sizeX;
  final double sizeY;
  final int columnLen;
  final int rowLen;
  final Color innerColor;
  final Color outColor;

  Hearts(
      {this.rowLen,
      this.columnLen,
      this.sizeX,
      this.sizeY,
      this.innerColor,
      this.outColor});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(children: [
      for (var i = 0; i < rowLen; i++)
        Column(children: <Widget>[
          for (var i = 0; i < columnLen; i++)
            new CustomPaint(
                size: Size(sizeX, sizeY),
                foregroundPainter: new HeartPainter(
                  innerColor: innerColor,
                  outColor: outColor,
                )),
        ]),
    ]);
  }
}

class HeartPainter extends CustomPainter {
  Color innerColor;
  Color outColor;

  HeartPainter({this.innerColor, this.outColor});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    paint
      ..color = outColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    Paint paint1 = Paint();
    paint1
      ..color = innerColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
        0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
        0.5 * width, height);

    canvas.drawPath(path, paint1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
