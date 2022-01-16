import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';


/// [StreamController]で[Position]を管理
/// [state]で[StreamController]を管理
class PositionNotifierController extends StateNotifier<StreamController<Position>> {
  PositionNotifierController() : super(StreamController<Position>());

  /// [Position]を送信開始
  Future<void> get start => _beginPositionFeatch();

  /// [Position]の送信停止
  Future<void> get stop => state.done;

  /// [Position]を送信開始
  Future<void> _beginPositionFeatch() async {
    if(await _checkPermission()) {
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      ).listen((Position position) {
        state.add(position);  // [Position]をstateに送信
      });
    }
  }

  /// 位置情報が許可されているか確認する
  Future<bool> _checkPermission() async {
    late bool _serviceEnabled;
    late LocationPermission _permission;
    try {
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        throw ("ServiceError");
      }
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        if (_permission == LocationPermission.denied) {
          throw ("DeniedPermissionError");
        }
      } else if (_permission == LocationPermission.whileInUse) {
        if (Platform.isAndroid) {
          throw ("WhileInUseError");
        } else {
          return true;
        }
      } else if (_permission == LocationPermission.deniedForever) {
        throw ("DeniedForeverError");
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}

/// [PositionNotifierController]を管理
final fetchPositionProvider = StateNotifierProvider<PositionNotifierController, StreamController<Position>>((_) => PositionNotifierController());

/// [Position]を[Stream]で送信する
final locationProvider = StreamProvider.autoDispose<Position>((ref) async* {
  final controller = ref.watch(fetchPositionProvider.notifier);
  controller.start;  // [Position]の取得開始
  ref.onDispose(() => controller.stop);  // [Position]の取得停止

  // Parse the value
  await for (final location in ref.watch(fetchPositionProvider).stream) {
    yield location;
  }
});
