import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Simple backend URL — use emulator localhost mapping for Android: 10.0.2.2
const String kBackendUrl = String.fromEnvironment(
  'NOTIFS_BACKEND',
  defaultValue: 'http://10.0.2.2:3000',
);

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _ensureInitialized();
  await _showLocalNotification(message);
  await _persistMessage(message);
}

Future<void> _ensureInitialized() async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  final android = AndroidNotificationDetails(
    'kidtopia_channel',
    'Kidtopia Notifications',
    channelDescription: 'Messages from Kidtopia backend',
    importance: Importance.max,
    priority: Priority.high,
  );
  final platform = NotificationDetails(android: android);

  final title =
      message.notification?.title ?? message.data['title'] ?? 'Kidtopia';
  final body = message.notification?.body ?? message.data['body'] ?? '';

  try {
    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      platform,
      payload: jsonEncode(message.data),
    );
  } catch (e, st) {
    // If local notifications are not available / initialized, persist the message
    // and show an in-app snackbar if possible
    try {
      await _persistMessage(message);
    } catch (_) {}

    final ctx = NotificationService()._navigatorKey?.currentState?.context;
    if (ctx != null) {
      final messenger = ScaffoldMessenger.maybeOf(ctx);
      messenger?.showSnackBar(SnackBar(content: Text('$title — $body')));
    } else {
      // Last-resort: print to console for debugging
      // ignore: avoid_print
      print('Notification show failed: $e\n$st');
    }
  }
}

Future<void> _persistMessage(RemoteMessage message) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('messages') ?? '[]';
  final list = jsonDecode(raw) as List<dynamic>;
  final entry = {
    'title': message.notification?.title ?? message.data['title'] ?? 'Kidtopia',
    'body': message.notification?.body ?? message.data['body'] ?? '',
    'data': message.data,
    'timestamp': DateTime.now().toIso8601String(),
  };
  list.insert(0, entry);
  await prefs.setString('messages', jsonEncode(list));
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _initialized = false; // messaging initialized
  bool _localInitialized = false;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Initialize only the local notification plugin (safe on all platforms).
  Future<void> initLocal(GlobalKey<NavigatorState> navigatorKey) async {
    if (_localInitialized) return;
    _navigatorKey = navigatorKey;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    try {
      await _flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: androidInit, iOS: iosInit),
        onDidReceiveNotificationResponse: (details) {
          try {
            final data = details.payload != null
                ? jsonDecode(details.payload!) as Map<String, dynamic>
                : <String, dynamic>{};
            final screen = data['screen'] as String?;
            if (screen != null) {
              _navigatorKey?.currentState?.pushNamed(screen);
            } else {
              _navigatorKey?.currentState?.pushNamed('/messages');
            }
          } catch (e) {}
        },
      );
      _localInitialized = true;
    } catch (e) {
      _localInitialized = false;
      rethrow;
    }
  }

  /// Initialize messaging features (calls `initLocal` first).
  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    if (_initialized) return;

    // Always ensure local notifications are initialized
    await initLocal(navigatorKey);

    // Only set up Firebase messaging on mobile platforms
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    _initialized = true;

    // Initialize Firebase if possible
    try {
      await Firebase.initializeApp();
    } catch (_) {}

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request permissions and get token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // user denied permissions
    }

    final token = await messaging.getToken();
    if (token != null) {
      // send token to backend for targeted messages
      try {
        await http.post(
          Uri.parse('$kBackendUrl/register-token'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': token}),
        );
      } catch (e) {}
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message);
      await _persistMessage(message);
    });

    // When user taps on a terminated/background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final screen = message.data['screen'] as String?;
      if (screen != null) {
        _navigatorKey?.currentState?.pushNamed(screen);
      } else {
        _navigatorKey?.currentState?.pushNamed('/messages');
      }
    });
  }

  /// Show a local test notification and persist it locally (useful for testing without FCM)
  Future<void> sendTestNotification({
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    // Ensure local notifications are initialized; if init throws, fall back gracefully
    if (!_localInitialized) {
      try {
        await initLocal(_navigatorKey ?? GlobalKey<NavigatorState>());
      } catch (e) {
        // Initialization failed; persist the message and show a simple in-app snackbar if possible
        final fallbackMessage = {
          'title': title,
          'body': body,
          'data': data ?? {},
          'timestamp': DateTime.now().toIso8601String(),
        };
        try {
          final prefs = await SharedPreferences.getInstance();
          final raw = prefs.getString('messages') ?? '[]';
          final list = jsonDecode(raw) as List<dynamic>;
          list.insert(0, fallbackMessage);
          await prefs.setString('messages', jsonEncode(list));
        } catch (_) {}

        final ctx = _navigatorKey?.currentState?.context;
        if (ctx != null) {
          ScaffoldMessenger.maybeOf(
            ctx,
          )?.showSnackBar(SnackBar(content: Text('$title — $body')));
        }
        return;
      }
    }

    final dummyMessage = RemoteMessage(
      notification: RemoteNotification(title: title, body: body),
      data: data ?? {},
    );

    try {
      await _showLocalNotification(dummyMessage);
    } catch (_) {
      // _showLocalNotification handles persisting and snackbar fallback
    }
    await _persistMessage(dummyMessage);
  }
}
