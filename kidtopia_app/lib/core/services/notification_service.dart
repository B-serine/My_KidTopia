import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import '../../../l10n/app_localizations.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  // Localization strings - can be set by the app
  late AppLocalizations l10n;

  void setLocalization(AppLocalizations localizations) {
    l10n = localizations;
  }

  // Initialize notifications
  Future<void> initialize() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();
  }

  // Request notification permissions (mainly for iOS)
  Future<void> _requestPermissions() async {
    try {
      final bool? result = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      
      if (result != null) {
        print('iOS notification permission: $result');
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // You can navigate to specific screen here if needed
  }

  // Show immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'quiz_reminder_channel',
      l10n.quizReminders,
      channelDescription: l10n.quizRemindersDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Schedule periodic notifications using WorkManager
  Future<void> schedulePeriodicReminders() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Set to false in production
    );

    // Register periodic task (runs every 2 days)
    await Workmanager().registerPeriodicTask(
      'quiz_reminder_task',
      'quizReminderTask',
      frequency: const Duration(days: 2), // Every 2 days
      initialDelay: const Duration(minutes: 1), // First notification after 1 minute
      constraints: Constraints(
        networkType: NetworkType.notRequired, // FIXED: Changed from not_required
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      inputData: {
        'title': l10n.timeToPlay,
        'body': l10n.timeToPlayBody,
      },
    );

    print(l10n.periodicReminderScheduled);
  }

  // Cancel all scheduled tasks
  Future<void> cancelAllReminders() async {
    await Workmanager().cancelAll();
    print(l10n.allReminersCancelled);
  }

  // Cancel specific task
  Future<void> cancelReminder(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
    print(l10n.reminderCancelled(uniqueName));
  }
}

// This MUST be a top-level function (outside the class)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Show notification when background task runs
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'quiz_reminder_channel',
        'Quiz Reminders',
        channelDescription: 'Notifications to remind users to play quiz',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await notificationsPlugin.show(
        DateTime.now().millisecond, // Unique ID
        inputData?['title'] ?? '🎮 Time to Play!',
        inputData?['body'] ?? 'Ready for some fun quizzes? Let\'s learn! 🌟',
        notificationDetails,
      );

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}