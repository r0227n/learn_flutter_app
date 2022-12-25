import 'package:flutter/material.dart';

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
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: KeyboardMods(
        mods: [
          Container(
            height: 100,
            width: 200,
            color: Colors.green,
          )
        ],
        child: Column(
          children: <Widget>[
            const TextField(),
            Container(
              height: 200,
              width: 100,
              color: Colors.red,
            ),
            Container(
              height: 200,
              width: 100,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardMods extends StatefulWidget {
  const KeyboardMods({
    required this.mods,
    required this.child,
    this.height = 50.0,
    this.width,
    super.key,
  });

  /// Widget displayed above the keyboard
  final List<Widget> mods;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Height of widget displayed above keyboard
  /// default value is 50.0
  final double height;

  /// Width of widget displayed above keyboard
  final double? width;

  @override
  State<KeyboardMods> createState() => _KeyboardModsState();
}

class _KeyboardModsState extends State<KeyboardMods> {
  late final FocusNode _node;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(debugLabel: 'KeyboardMods');
    _node.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_node.hasFocus != _visible) {
      setState(() {
        _visible = _node.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Focus(
            focusNode: _node,
            child: widget.child,
          ),
          Visibility(
            visible: _visible,
            child: Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: SizedBox(
                height: widget.height,
                width: widget.width,
                child: Row(
                  children: widget.mods,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
