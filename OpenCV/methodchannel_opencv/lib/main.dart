import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Do OpenCV with MethodChannel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.dev/image');
  Image image = Image.asset("images/icon.jpeg");

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
            image,
            ElevatedButton(
              onPressed: () {
                setState((){
                  image = Image.asset("images/icon.jpeg");
                });
              },
              child: Text('undo'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final opencv = await _processOpenCVWithMethodChannel();
                  setState((){
                    image = Image.memory(base64Decode(opencv));
                  });
                } catch(e) {
                  print(e);
                }
              },
              child: Text('Process OpenCV with MethodChannel'),
            )
          ],
        ),
      ),
    );
  }

  Future<String> _processOpenCVWithMethodChannel() async {
    ByteData imageData = await rootBundle.load('images/icon.jpeg');
    String base64 = base64Encode(Uint8List.view(imageData.buffer));
    String result = await platform.invokeMethod('getBase64', base64);
    return result;
  }
}
