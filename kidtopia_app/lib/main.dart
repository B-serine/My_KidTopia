import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

// Database
import 'data/databases/db_helper.dart';

// Repositories
import 'data/repositories/user_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/quiz_repository.dart';

// Cubits
import 'logic/cubits/auth_cubit.dart';
import 'logic/cubits/category_cubit.dart';
import 'logic/cubits/quiz_cubit.dart';
import 'logic/cubits/locale_cubit.dart';

// Screens
import 'screens/home.dart';
import 'screens/sign_up.dart';
import 'screens/categories.dart';
import 'screens/quiz.dart';
import 'screens/sign_in.dart';
import 'screens/score.dart';
import 'screens/profile.dart';

// Game screens
import 'screens/games/water_sort.dart';
import 'screens/games/RainbowMonsterGame.dart';
import 'screens/games/PetFeedingGame.dart';
import 'screens/games/MemoryCardGame.dart';
import 'screens/games/FoodMemoryGame.dart';
import 'screens/games/MatchingGame.dart';

// App colors
import 'assets/app_colors/app_colors.dart';

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // 3. Initialize FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4. Initialize Supabase
  await Supabase.initialize(
    url: 'https://dwfrpbgpqzhjmomcoqgo.supabase.co',
    anonKey: 'sb_publishable_jQx7zwFRf5FiNtgDlYw82w_w1Hk9AsR', // Replace with your Supabase key
  );

  runApp(const KidtopiaApp());
}

// Global Supabase client access
final supabase = Supabase.instance.client;

class KidtopiaApp extends StatelessWidget {
  const KidtopiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DatabaseInitializer();
  }
}

class DatabaseInitializer extends StatefulWidget {
  const DatabaseInitializer({super.key});

  @override
  State<DatabaseInitializer> createState() => _DatabaseInitializerState();
}

class _DatabaseInitializerState extends State<DatabaseInitializer> {
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      await DatabaseHelper.instance.database;
      await DatabaseHelper.instance.seedFromAssetsIfEmpty();
      
      // Request notification permissions
      await _setupNotifications();
      
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize database: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _setupNotifications() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Notification permission: ${settings.authorizationStatus}');

      // Get FCM token
      String? token = await messaging.getToken();
      print('FCM Token: $token');

      // Save token to Supabase if user is logged in
      final userId = supabase.auth.currentUser?.id;
      if (token != null && userId != null) {
        await supabase.from('profiles').update({
          'fcm_token': token,
        }).eq('id', userId);
      }

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message: ${message.notification?.title}');
        // You can show a local notification here
      });

      // Handle when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('App opened from notification: ${message.data}');
        // Navigate based on message data
      });
    } catch (e) {
      print('Error setting up notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _buildErrorScreen();
    }

    if (!_isInitialized) {
      return _buildSplashScreen();
    }

    return _buildMainApp();
  }

  Widget _buildErrorScreen() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: brandBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: brandRed),
                const SizedBox(height: 16),
                Text(
                  'Initialization Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: brandTextDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: brandTextLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    _initializeDatabase();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: brandPurple),
                  child: Text('Retry', style: TextStyle(color: brandWhite)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashScreen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: brandBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: brandPurple,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: brandPurple.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.child_care,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Kidtopia',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: brandPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Learning made fun!',
                style: TextStyle(fontSize: 16, color: brandTextLight),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(color: brandPurple),
              const SizedBox(height: 16),
              Text(
                'Initializing...',
                style: TextStyle(color: brandTextLight, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainApp() {
    final userRepository = UserRepository();
    final categoryRepository = CategoryRepository();
    final quizRepository = QuizRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (_) => userRepository),
        RepositoryProvider<CategoryRepository>(
          create: (_) => categoryRepository,
        ),
        RepositoryProvider<QuizRepository>(
          create: (_) => quizRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(userRepository),
          ),
          BlocProvider<CategoryCubit>(
            create: (context) => CategoryCubit(categoryRepository),
          ),
          BlocProvider<QuizCubit>(
            create: (context) => QuizCubit(quizRepository),
          ),
          BlocProvider<LocaleCubit>(
            create: (context) => LocaleCubit(),
          ),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              
              // Localization configuration
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('fr'), // French
                Locale('ar'), // Arabic
              ],
              locale: locale,
              
              theme: ThemeData(
                textTheme: GoogleFonts.comfortaaTextTheme(),
                useMaterial3: true,
              ),
              title: 'Kidtopia',
              initialRoute: '/sign_up',
              routes: {
                '/': (context) => const HomeScreen(),
                '/sign_up': (context) => const SignUpScreen(),
                '/categories': (context) => const CategoriesScreen(),
                '/quiz': (context) => const QuizScreen(),
                '/sign_in': (context) => const SignInScreen(),
                '/score': (context) => const ScoreScreen(),
                '/profile': (context) => const ProfileScreen(),
                '/food_memory_game': (context) => const FoodMemoryGame(),
                '/matching_game': (context) => const MatchingGame(),
                '/memory_card_game': (context) => const MemoryCardGame(),
                '/pet_feeding_game': (context) => const PetFeedingGame(),
                '/rainbow_monster_game': (context) => const RainbowMonsterGame(),
                '/water_sort_game': (context) => const WaterSortGame(),
              },
            );
          },
        ),
      ),
    );
  }
}