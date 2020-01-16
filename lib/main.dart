import 'package:flutter/material.dart';
import 'package:flutter_bdmap/flutter_bdmap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
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
          primarySwatch: Colors.blue,
        ),
        home: IndexPage());
  }
}

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: Center(
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) {
                return MyHomePage(
                  title: "---",
                );
              }));
            },
            child: Text("去到地图界面")),
      ),
    );
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
  MapViewController mapViewController;

  @override
  void initState() {
    mapViewController = new MapViewController();
    mapViewController.onMarkerClick = (userId) {
      print("点击了$userId");
    };
    super.initState();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("百度地图demo"),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: BDMapView(
          controller: mapViewController,
          onViewCreated: onMapViewCreated,
        )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  onMapViewCreated() {
    List<MarkerInfo> markerInfos = [];

    markerInfos.add(MarkerInfo(
        userId: "123",
        headUrl:
            "https://goss.veer.com/creative/vcg/veer/800water/veer-134671947.jpg",
        title: "张三",
        subTitle: "App",
        latitude: 22.545585,
        longitude: 113.973212));

    markerInfos.add(MarkerInfo(
        userId: "456",
        headUrl:
            "https://goss.veer.com/creative/vcg/veer/800water/veer-171124464.jpg",
        title: "李四",
        subTitle: "小程序王者",
        latitude: 22.57836,
        longitude: 113.97429));
    markerInfos.add(MarkerInfo(
        userId: "789",
        headUrl:
            "https://goss.veer.com/creative/vcg/veer/800water/veer-309677502.jpg",
        title: "王五",
        subTitle: "小程序王者",
        latitude: 22.630142,
        longitude: 113.947844));

    mapViewController.showMarkers(markerInfos);
  }
}
