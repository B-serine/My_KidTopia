import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Initialize database factory for desktop platforms (Windows, Linux, macOS)
  static void initializeDatabaseFactory() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize FFI for desktop
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kidtopia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Incremented version for new schema
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        try {
          await db.execute('PRAGMA foreign_keys = ON');
          await db.execute('PRAGMA journal_mode = WAL');
        } catch (_) {}
      },
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Drop old tables
      try {
        await db.execute('DROP TABLE IF EXISTS answers');
        await db.execute('DROP TABLE IF EXISTS questions');
      } catch (_) {}

      // Create new quizzes table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS quizzes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category_id INTEGER NOT NULL,
          question_text TEXT NOT NULL,
          image_url TEXT,
          answer1 TEXT NOT NULL,
          answer2 TEXT NOT NULL,
          answer3 TEXT NOT NULL,
          answer4 TEXT NOT NULL,
          correct_answers TEXT NOT NULL DEFAULT '1',
          points INTEGER DEFAULT 10,
          level INTEGER DEFAULT 1,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
        )
      ''');

      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_quizzes_category ON quizzes(category_id)',
      );

      // Seed quizzes data
      await _seedQuizzes(db);
    }

    // Handle password column migration from earlier versions
    if (oldVersion < 2) {
      try {
        await db.execute("ALTER TABLE users ADD COLUMN password TEXT");
      } catch (_) {}
    }
  }

  Future _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT UNIQUE,
        password TEXT,
        age INTEGER,
        avatar_url TEXT,
        total_score INTEGER DEFAULT 0,
        is_premium INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        image_url TEXT,
        color TEXT,
        is_active INTEGER DEFAULT 1,
        required_score INTEGER DEFAULT 0,
        is_premium INTEGER DEFAULT 0
      )
    ''');

    // NEW: Quizzes table (replaces questions + answers)
    await db.execute('''
      CREATE TABLE quizzes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        image_url TEXT,
        answer1 TEXT NOT NULL,
        answer2 TEXT NOT NULL,
        answer3 TEXT NOT NULL,
        answer4 TEXT NOT NULL,
        correct_answers TEXT NOT NULL DEFAULT '1',
        points INTEGER DEFAULT 10,
        level INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_quizzes_category ON quizzes(category_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(is_active)',
    );

    // Seed categories
    await _seedCategories(db);

    // Seed quizzes
    await _seedQuizzes(db);
  }

  Future<void> _seedCategories(Database db) async {
    // 5 unlocked categories
    await db.insert('categories', {
      'name': 'Animals',
      'description': 'Learn about different animals',
      'color': '#FF8B5CF6',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    await db.insert('categories', {
      'name': 'Fruits',
      'description': 'Learn about different fruits',
      'color': '#FFF97316',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    await db.insert('categories', {
      'name': 'Vegetables',
      'description': 'Learn about healthy vegetables',
      'color': '#FF22C55E',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    await db.insert('categories', {
      'name': 'Numbers',
      'description': 'Learn to count and recognize numbers',
      'color': '#FFEAB308',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    await db.insert('categories', {
      'name': 'Shapes',
      'description': 'Learn about geometric shapes',
      'color': '#FF06B6D4',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    // 3 score-locked categories
    await db.insert('categories', {
      'name': 'Transportation',
      'description': 'Learn about different vehicles',
      'color': '#FF3B82F6',
      'is_active': 1,
      'required_score': 50,
      'is_premium': 0,
    });

    await db.insert('categories', {
      'name': 'Colors',
      'description': 'Learn about colors and shades',
      'color': '#FFEC4899',
      'is_active': 1,
      'required_score': 100,
      'is_premium': 0,
    });

    await db.insert('categories', {
      'name': 'Emotions',
      'description': 'Learn about emotions and feelings',
      'color': '#FFD4AF37',
      'is_active': 1,
      'required_score': 30,
      'is_premium': 0,
    });

    // 2 premium categories
    await db.insert('categories', {
      'name': 'Music',
      'description': 'Learn about musical instruments',
      'color': '#FFA855F7',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 1,
    });

    await db.insert('categories', {
      'name': 'Sports',
      'description': 'Learn about different sports',
      'color': '#FFF43F5E',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 1,
    });
  }

  Future<void> _seedQuizzes(Database db) async {
    // Helper function to insert quiz
    Future<void> insertQuiz({
      required int categoryId,
      required String question,
      required String a1,
      required String a2,
      required String a3,
      required String a4,
      required String correctAnswers, // e.g., "1" or "1,3" for multiple
      int points = 10,
    }) async {
      await db.insert('quizzes', {
        'category_id': categoryId,
        'question_text': question,
        'answer1': a1,
        'answer2': a2,
        'answer3': a3,
        'answer4': a4,
        'correct_answers': correctAnswers,
        'points': points,
        'level': 1,
      });
    }

    // ============================================================
    // ANIMALS (category_id = 1)
    // ============================================================
    await insertQuiz(categoryId: 1, question: 'Which animal says "meow"?', a1: 'Cat', a2: 'Dog', a3: 'Cow', a4: 'Sheep', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'Which is the fastest animal?', a1: 'Cheetah', a2: 'Lion', a3: 'Zebra', a4: 'Giraffe', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'What sound does a duck make?', a1: 'Quack', a2: 'Moo', a3: 'Baa', a4: 'Oink', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'Which animal has stripes?', a1: 'Zebra', a2: 'Giraffe', a3: 'Lion', a4: 'Elephant', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'What do bees make?', a1: 'Honey', a2: 'Milk', a3: 'Eggs', a4: 'Wax', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'How many legs does a spider have?', a1: '8', a2: '6', a3: '4', a4: '10', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'Which animal is the king of the jungle?', a1: 'Lion', a2: 'Tiger', a3: 'Elephant', a4: 'Bear', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'What is a baby dog called?', a1: 'Puppy', a2: 'Kitten', a3: 'Calf', a4: 'Chick', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'Which animal lives in water and lays eggs?', a1: 'Fish', a2: 'Duck', a3: 'Penguin', a4: 'Crocodile', correctAnswers: '1');
    await insertQuiz(categoryId: 1, question: 'What color is a flamingo?', a1: 'Pink', a2: 'Red', a3: 'White', a4: 'Yellow', correctAnswers: '1');
    // Multiple choice animals
    await insertQuiz(categoryId: 1, question: 'Which animals can fly?', a1: 'Bird', a2: 'Fish', a3: 'Bat', a4: 'Dog', correctAnswers: '1,3', points: 15);
    await insertQuiz(categoryId: 1, question: 'Which animals live in water?', a1: 'Fish', a2: 'Dolphin', a3: 'Lion', a4: 'Whale', correctAnswers: '1,2,4', points: 20);

    // ============================================================
    // FRUITS (category_id = 2)
    // ============================================================
    await insertQuiz(categoryId: 2, question: 'Which of these is a citrus fruit?', a1: 'Orange', a2: 'Banana', a3: 'Apple', a4: 'Grape', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'Which fruit is yellow?', a1: 'Banana', a2: 'Apple', a3: 'Orange', a4: 'Grape', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'What fruit is red and grows on trees?', a1: 'Apple', a2: 'Banana', a3: 'Lemon', a4: 'Lime', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'Which fruit grows in bunches?', a1: 'Grapes', a2: 'Apple', a3: 'Pear', a4: 'Peach', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'What is a small round red fruit?', a1: 'Strawberry', a2: 'Blueberry', a3: 'Raspberry', a4: 'Blackberry', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'Which fruit is tropical and has a crown?', a1: 'Pineapple', a2: 'Papaya', a3: 'Mango', a4: 'Coconut', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'What color is a ripe blueberry?', a1: 'Blue', a2: 'Red', a3: 'Purple', a4: 'Black', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'Which fruit looks like a tiny orange?', a1: 'Tangerine', a2: 'Lime', a3: 'Lemon', a4: 'Grapefruit', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'What is a sweet yellow tropical fruit?', a1: 'Mango', a2: 'Papaya', a3: 'Guava', a4: 'Passion fruit', correctAnswers: '1');
    await insertQuiz(categoryId: 2, question: 'Which fruits are berries?', a1: 'Strawberry', a2: 'Apple', a3: 'Blueberry', a4: 'Orange', correctAnswers: '1,3', points: 15);
    await insertQuiz(categoryId: 2, question: 'Which are citrus fruits?', a1: 'Lemon', a2: 'Apple', a3: 'Orange', a4: 'Banana', correctAnswers: '1,3', points: 15);

    // ============================================================
    // VEGETABLES (category_id = 3)
    // ============================================================
    await insertQuiz(categoryId: 3, question: 'Which is a vegetable?', a1: 'Carrot', a2: 'Strawberry', a3: 'Mango', a4: 'Orange', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'Which vegetable is orange?', a1: 'Carrot', a2: 'Pea', a3: 'Corn', a4: 'Bean', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'What vegetable grows underground?', a1: 'Potato', a2: 'Tomato', a3: 'Lettuce', a4: 'Cucumber', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'Which is a leafy green vegetable?', a1: 'Spinach', a2: 'Carrot', a3: 'Onion', a4: 'Pepper', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'What vegetable makes you cry?', a1: 'Onion', a2: 'Garlic', a3: 'Leek', a4: 'Shallot', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'Which vegetable is red and round?', a1: 'Tomato', a2: 'Pepper', a3: 'Radish', a4: 'Beet', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'What vegetable has florets?', a1: 'Broccoli', a2: 'Lettuce', a3: 'Carrot', a4: 'Cucumber', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'Which vegetable is long and green?', a1: 'Cucumber', a2: 'Zucchini', a3: 'Bean', a4: 'Pea', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'What vegetable grows in pods?', a1: 'Pea', a2: 'Carrot', a3: 'Potato', a4: 'Turnip', correctAnswers: '1');
    await insertQuiz(categoryId: 3, question: 'Which vegetables grow underground?', a1: 'Potato', a2: 'Tomato', a3: 'Carrot', a4: 'Lettuce', correctAnswers: '1,3', points: 15);

    // ============================================================
    // NUMBERS (category_id = 4)
    // ============================================================
    await insertQuiz(categoryId: 4, question: 'What number comes after 2?', a1: '3', a2: '1', a3: '4', a4: '5', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'What is 1 + 1?', a1: '2', a2: '1', a3: '3', a4: '4', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'Which number is bigger: 5 or 3?', a1: '5', a2: '3', a3: 'They are equal', a4: 'None', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'What number comes before 5?', a1: '4', a2: '5', a3: '6', a4: '3', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'How many fingers on one hand?', a1: '5', a2: '4', a3: '6', a4: '10', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'What is 2 + 3?', a1: '5', a2: '4', a3: '6', a4: '3', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'How many sides does a triangle have?', a1: '3', a2: '4', a3: '2', a4: '5', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'What comes after 7?', a1: '8', a2: '7', a3: '9', a4: '6', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'Count the fingers: how many is 2 hands?', a1: '10', a2: '5', a3: '8', a4: '12', correctAnswers: '1');
    await insertQuiz(categoryId: 4, question: 'Which numbers are even?', a1: '2', a2: '3', a3: '4', a4: '5', correctAnswers: '1,3', points: 15);
    await insertQuiz(categoryId: 4, question: 'Which numbers are odd?', a1: '1', a2: '2', a3: '3', a4: '4', correctAnswers: '1,3', points: 15);

    // ============================================================
    // SHAPES (category_id = 5)
    // ============================================================
    await insertQuiz(categoryId: 5, question: 'Which shape has 4 equal sides?', a1: 'Square', a2: 'Triangle', a3: 'Circle', a4: 'Rectangle', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'Which shape is round?', a1: 'Circle', a2: 'Square', a3: 'Triangle', a4: 'Rectangle', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'How many sides does a circle have?', a1: 'None', a2: '1', a3: '2', a4: '4', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'Which shape has 3 sides?', a1: 'Triangle', a2: 'Square', a3: 'Circle', a4: 'Pentagon', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'A rectangle is longer than it is tall, true or false?', a1: 'True', a2: 'False', a3: 'Sometimes', a4: 'Never', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'How many corners does a triangle have?', a1: '3', a2: '2', a3: '4', a4: '5', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'Which shape looks like a star?', a1: 'Star', a2: 'Circle', a3: 'Square', a4: 'Triangle', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'What shape is a stop sign?', a1: 'Octagon', a2: 'Square', a3: 'Pentagon', a4: 'Hexagon', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'A diamond shape has how many sides?', a1: '4', a2: '3', a3: '5', a4: '6', correctAnswers: '1');
    await insertQuiz(categoryId: 5, question: 'Which shapes have 4 sides?', a1: 'Square', a2: 'Triangle', a3: 'Rectangle', a4: 'Circle', correctAnswers: '1,3', points: 15);

    // ============================================================
    // TRANSPORTATION (category_id = 6)
    // ============================================================
    await insertQuiz(categoryId: 6, question: 'Which vehicle flies?', a1: 'Airplane', a2: 'Car', a3: 'Boat', a4: 'Bicycle', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'Which vehicle is used on water?', a1: 'Boat', a2: 'Car', a3: 'Train', a4: 'Bus', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'What vehicle runs on train tracks?', a1: 'Train', a2: 'Car', a3: 'Bus', a4: 'Bike', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'Which vehicle has two wheels?', a1: 'Bicycle', a2: 'Car', a3: 'Bus', a4: 'Truck', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'What is a person who drives a bus called?', a1: 'Bus driver', a2: 'Pilot', a3: 'Captain', a4: 'Engineer', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'Which vehicle carries lots of people?', a1: 'Bus', a2: 'Car', a3: 'Bike', a4: 'Scooter', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'What vehicle has a big truck bed?', a1: 'Pickup truck', a2: 'Car', a3: 'Van', a4: 'Bus', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'Which vehicle needs gas to run?', a1: 'Car', a2: 'Bicycle', a3: 'Skateboard', a4: 'Scooter', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'What vehicle is used for emergency help?', a1: 'Ambulance', a2: 'Taxi', a3: 'Bus', a4: 'Car', correctAnswers: '1');
    await insertQuiz(categoryId: 6, question: 'Which vehicles have two wheels?', a1: 'Bicycle', a2: 'Car', a3: 'Motorcycle', a4: 'Bus', correctAnswers: '1,3', points: 15);

    // ============================================================
    // COLORS (category_id = 7)
    // ============================================================
    await insertQuiz(categoryId: 7, question: 'What color do you get by mixing red and blue?', a1: 'Purple', a2: 'Green', a3: 'Orange', a4: 'Brown', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color is the sky on a clear day?', a1: 'Blue', a2: 'Green', a3: 'Pink', a4: 'Yellow', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color is grass?', a1: 'Green', a2: 'Blue', a3: 'Brown', a4: 'Yellow', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color is a ripe tomato?', a1: 'Red', a2: 'Green', a3: 'Yellow', a4: 'Orange', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color is snow?', a1: 'White', a2: 'Blue', a3: 'Gray', a4: 'Clear', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color is a banana?', a1: 'Yellow', a2: 'Green', a3: 'Orange', a4: 'Brown', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color do you get by mixing red and yellow?', a1: 'Orange', a2: 'Green', a3: 'Purple', a4: 'Brown', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color do you get by mixing blue and yellow?', a1: 'Green', a2: 'Purple', a3: 'Orange', a4: 'Brown', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'What color is a fire truck?', a1: 'Red', a2: 'Blue', a3: 'Yellow', a4: 'White', correctAnswers: '1');
    await insertQuiz(categoryId: 7, question: 'Which are primary colors?', a1: 'Red', a2: 'Orange', a3: 'Blue', a4: 'Yellow', correctAnswers: '1,3,4', points: 20);
    await insertQuiz(categoryId: 7, question: 'Which colors are warm colors?', a1: 'Red', a2: 'Blue', a3: 'Orange', a4: 'Yellow', correctAnswers: '1,3,4', points: 15);

    // ============================================================
    // EMOTIONS (category_id = 8)
    // ============================================================
    await insertQuiz(categoryId: 8, question: 'Which emotion shows happiness?', a1: 'Smiling', a2: 'Crying', a3: 'Angry', a4: 'Scared', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'Which emotion means you are sad?', a1: 'Sad', a2: 'Happy', a3: 'Angry', a4: 'Scared', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'What emotion do you feel when something is funny?', a1: 'Laughing', a2: 'Crying', a3: 'Angry', a4: 'Scared', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'Which emotion shows fear?', a1: 'Scared', a2: 'Happy', a3: 'Calm', a4: 'Confident', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'What emotion do you have when you are not calm?', a1: 'Angry', a2: 'Happy', a3: 'Sleepy', a4: 'Bored', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'Which emotion is opposite to sad?', a1: 'Happy', a2: 'Angry', a3: 'Scared', a4: 'Tired', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'What emotion do you have when something hurts?', a1: 'Pain', a2: 'Happy', a3: 'Calm', a4: 'Excited', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'Which emotion means you feel well?', a1: 'Good', a2: 'Bad', a3: 'Tired', a4: 'Bored', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'What do you feel when you see something exciting?', a1: 'Excited', a2: 'Bored', a3: 'Tired', a4: 'Sad', correctAnswers: '1');
    await insertQuiz(categoryId: 8, question: 'Which are positive emotions?', a1: 'Happy', a2: 'Sad', a3: 'Excited', a4: 'Angry', correctAnswers: '1,3', points: 15);

    // ============================================================
    // MUSIC (category_id = 9) - PREMIUM
    // ============================================================
    await insertQuiz(categoryId: 9, question: 'Which instrument has keys and many strings inside?', a1: 'Piano', a2: 'Drum', a3: 'Flute', a4: 'Guitar', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'Which instrument is blown like a whistle?', a1: 'Flute', a2: 'Drum', a3: 'Guitar', a4: 'Violin', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'What do you hit to make music with a drum?', a1: 'Drumsticks', a2: 'Mallets', a3: 'Hands', a4: 'Brushes', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'Which instrument has strings and is played with a bow?', a1: 'Violin', a2: 'Guitar', a3: 'Harp', a4: 'Lute', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'What instrument looks like a small harp?', a1: 'Ukulele', a2: 'Mandolin', a3: 'Banjo', a4: 'Lute', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'Which instrument is played by pressing keys?', a1: 'Keyboard', a2: 'Violin', a3: 'Guitar', a4: 'Trumpet', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'What instrument is shiny and loud?', a1: 'Trumpet', a2: 'Flute', a3: 'Clarinet', a4: 'Saxophone', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'How many strings does a guitar usually have?', a1: '6', a2: '4', a3: '8', a4: '12', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'Which instrument sounds like a cat?', a1: 'Saxophone', a2: 'Trumpet', a3: 'Flute', a4: 'Clarinet', correctAnswers: '1');
    await insertQuiz(categoryId: 9, question: 'Which are string instruments?', a1: 'Guitar', a2: 'Drum', a3: 'Violin', a4: 'Flute', correctAnswers: '1,3', points: 15);

    // ============================================================
    // SPORTS (category_id = 10) - PREMIUM
    // ============================================================
    await insertQuiz(categoryId: 10, question: 'Which sport uses a hoop and ball?', a1: 'Basketball', a2: 'Soccer', a3: 'Tennis', a4: 'Cricket', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'Which sport uses a ball and a racket?', a1: 'Tennis', a2: 'Basketball', a3: 'Soccer', a4: 'Volleyball', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'Which sport is played on grass with a ball?', a1: 'Soccer', a2: 'Tennis', a3: 'Basketball', a4: 'Baseball', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'What sport uses a bat and a ball?', a1: 'Baseball', a2: 'Tennis', a3: 'Soccer', a4: 'Golf', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'Which sport is played in a pool?', a1: 'Swimming', a2: 'Basketball', a3: 'Soccer', a4: 'Tennis', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'What sport involves running very fast?', a1: 'Track and field', a2: 'Basketball', a3: 'Tennis', a4: 'Golf', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'Which sport involves a net over grass?', a1: 'Volleyball', a2: 'Basketball', a3: 'Tennis', a4: 'Soccer', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'What sport uses an oval ball and a field?', a1: 'American Football', a2: 'Soccer', a3: 'Basketball', a4: 'Baseball', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'Which sport involves jumping on ice?', a1: 'Ice skating', a2: 'Hockey', a3: 'Basketball', a4: 'Tennis', correctAnswers: '1');
    await insertQuiz(categoryId: 10, question: 'Which sports use a ball?', a1: 'Soccer', a2: 'Swimming', a3: 'Basketball', a4: 'Running', correctAnswers: '1,3', points: 15);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  /// Seed database if quizzes table is empty (ensures quizzes exist even on upgrades).
  Future<void> seedFromAssetsIfEmpty() async {
    final db = await database;

    // Check if quizzes already exist
    final quizCountRes = await db.rawQuery(
      'SELECT COUNT(*) as count FROM quizzes',
    );
    final quizCount = quizCountRes.first['count'] as int? ?? 0;
    if (quizCount > 0) return; // quizzes already exist

    // Seed quizzes
    await _seedQuizzes(db);
  }
}
