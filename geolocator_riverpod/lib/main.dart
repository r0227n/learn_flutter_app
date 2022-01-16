import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' show Position;

import 'location.dart';


void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Position> gps = ref.watch(locationProvider);

    return gps.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (location) {
        return Display(location.latitude, location.longitude);
      },
    );
  }
}

class Display extends StatelessWidget {
  final double lat;
  final double log;
  Display(this.lat, this.log);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeolocatorRiverpod')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('緯度 : $lat'),
            Text('軽度 : $log'),
          ],
        ),
      ),
    );
  }
}

