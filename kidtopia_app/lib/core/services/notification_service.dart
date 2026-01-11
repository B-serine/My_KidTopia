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
  AppLocalizations? l10n;

  void setLocalization(AppLocalizations localizations) {
    l10n = localizations;
  }

  // Initialize notifications
  Future<void> initialize() async {
    print('NotificationService: Initializing...');
    
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

    // Create notification channels for Android
    await _createAndroidNotificationChannels();

    // Request permissions for iOS
    await _requestPermissions();
    
    print('NotificationService: Initialization complete');
  }

  // Create Android notification channels
  Future<void> _createAndroidNotificationChannels() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'quiz_reminder_channel',
        'Quiz Reminders',
        description: 'Notifications to remind you to play quiz',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      
      print('NotificationService: Notification channel created');
    } catch (e) {
      print('NotificationService: Error creating notification channel: $e');
    }
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
      l10n?.quizReminders ?? 'Quiz Reminders',
      channelDescription: l10n?.quizRemindersDescription ?? 'Notifications to remind you to play quiz',
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
    try {
      print('NotificationService: Starting notification scheduling...');
      
      // Initialize Workmanager first
      print('NotificationService: Initializing Workmanager...');
      await Workmanager().initialize(
        callbackDispatcher,
      );
      print('NotificationService: Workmanager initialized successfully');

      // Cancel any existing tasks
      print('NotificationService: Clearing existing tasks...');
      await Workmanager().cancelAll();
      print('NotificationService: Existing tasks cleared');

      // Schedule a one-time task to run after 2 minutes
      print('NotificationService: Scheduling one-time notification (2 minutes)...');
      await Workmanager().registerOneOffTask(
        'quiz_reminder_once_${DateTime.now().millisecondsSinceEpoch}',
        'quizReminderTask',
        initialDelay: const Duration(minutes: 2),
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        inputData: {
          'title': l10n?.timeToPlay ?? '🎮 Time to Play!',
          'body': l10n?.timeToPlayBody ?? 'Ready for some fun quizzes? Let\'s learn! 🌟',
        },
        backoffPolicy: BackoffPolicy.exponential,
      );
      print('NotificationService: One-time task scheduled (will trigger in ~2 minutes)');

      // Then schedule periodic task to run every day
      print('NotificationService: Scheduling daily notifications...');
      await Workmanager().registerPeriodicTask(
        'quiz_reminder_daily_${DateTime.now().millisecondsSinceEpoch}',
        'quizReminderTask',
        frequency: const Duration(days: 1), // Every day
        initialDelay: const Duration(minutes: 1), // Start at 2 minutes, then repeat every day
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        inputData: {
          'title': l10n?.timeToPlay ?? '🎮 Time to Play!',
          'body': l10n?.timeToPlayBody ?? 'Ready for some fun quizzes? Let\'s learn! 🌟',
        },
        backoffPolicy: BackoffPolicy.linear,
        backoffPolicyDelay: const Duration(seconds: 10),
      );
      
      print('NotificationService: ✓ Daily task registered successfully');
      print('NotificationService: ✓ Notification schedule:');
      print('  - First notification: ~2 minutes');
      print('  - Then every day (24 hours)');
      print('NotificationService: ✓ Notification scheduling complete!');
    } catch (e, stackTrace) {
      print('NotificationService: ❌ Error scheduling reminders: $e');
      print('NotificationService: Stack trace: $stackTrace');
    }
  }

  // Cancel all scheduled tasks
  Future<void> cancelAllReminders() async {
    await Workmanager().cancelAll();
    print(l10n?.allReminersCancelled ?? 'All reminders cancelled');
  }

  // Cancel specific task
  Future<void> cancelReminder(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
    print(l10n?.reminderCancelled(uniqueName) ?? 'Reminder cancelled: $uniqueName');
  }

  // Test notification - shows immediately (useful for debugging)
  Future<void> testNotification() async {
    await showNotification(
      title: '🎮 Test Notification',
      body: 'If you see this, notifications are working!',
    );
  }
}

// This MUST be a top-level function (outside the class)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('\n\n');
    print('═══════════════════════════════════════════════');
    print('🔔 BACKGROUND NOTIFICATION TASK TRIGGERED');
    print('═══════════════════════════════════════════════');
    print('Task Name: $task');
    print('Time: ${DateTime.now()}');
    
    try {
      // Initialize notifications plugin in background
      print('Step 1: Initializing notification plugin...');
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // Initialize the plugin
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: androidInitializationSettings,
      );

      await notificationsPlugin.initialize(initializationSettings);
      print('Step 1: ✓ Notification plugin initialized');

      // Create notification channel
      print('Step 2: Creating notification channel...');
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'quiz_reminder_channel',
        'Quiz Reminders',
        description: 'Notifications to remind users to play quiz',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      print('Step 2: ✓ Notification channel created');

      // Build notification details
      print('Step 3: Building notification details...');
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'quiz_reminder_channel',
        'Quiz Reminders',
        channelDescription: 'Notifications to remind users to play quiz',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
        enableVibration: true,
        playSound: true,
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
      print('Step 3: ✓ Notification details built');

      // Prepare data
      final notificationId = DateTime.now().millisecond;
      final title = inputData?['title'] ?? '🎮 Time to Play!';
      final body = inputData?['body'] ?? 'Ready for some fun quizzes? Let\'s learn! 🌟';
      
      print('Step 4: Showing notification...');
      print('  ID: $notificationId');
      print('  Title: $title');
      print('  Body: $body');
      
      // Show the notification
      await notificationsPlugin.show(
        notificationId,
        title,
        body,
        notificationDetails,
      );

      print('Step 4: ✓ Notification shown successfully');
      print('═══════════════════════════════════════════════');
      print('🔔 BACKGROUND TASK COMPLETED SUCCESSFULLY');
      print('═══════════════════════════════════════════════\n');
      
      return Future.value(true);
    } catch (e, stackTrace) {
      print('═══════════════════════════════════════════════');
      print('❌ ERROR IN BACKGROUND TASK');
      print('═══════════════════════════════════════════════');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      print('═══════════════════════════════════════════════\n');
      return Future.value(false);
    }
  });
}
