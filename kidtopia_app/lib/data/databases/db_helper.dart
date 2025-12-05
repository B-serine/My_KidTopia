import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

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
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldV, newV) async {
        // migrate existing DB: add password column to users if missing
        try {
          await db.execute("ALTER TABLE users ADD COLUMN password TEXT");
        } catch (_) {}
        try {
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_questions_category ON questions(category_id)',
          );
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_answers_question ON answers(question_id)',
          );
          await db.execute(
            'CREATE INDEX IF NOT EXISTS idx_categories_active ON categories(is_active)',
          );
        } catch (_) {}
      },
      onOpen: (db) async {
        try {
          await db.execute('PRAGMA foreign_keys = ON');
          await db.execute('PRAGMA journal_mode = WAL');
        } catch (_) {}
      },
    );
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

    // Questions table
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        image_url TEXT,
        level INTEGER DEFAULT 1,
        points INTEGER DEFAULT 10,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Answers table
    await db.execute('''
      CREATE TABLE answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer_text TEXT NOT NULL,
        is_correct INTEGER DEFAULT 0,
        display_order INTEGER DEFAULT 0,
        FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE
      )
    ''');

    // Seed categories in the requested order:
    // 5 unlocked, 3 closed (score-locked), 2 premium (music and sports)
    final animalsId = await db.insert('categories', {
      'name': 'Animals',
      'description': 'Learn about different animals',
      'color': '#FF8B5CF6',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    final fruitsId = await db.insert('categories', {
      'name': 'Fruits',
      'description': 'Learn about different fruits',
      'color': '#FFF97316',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    final vegetablesId = await db.insert('categories', {
      'name': 'Vegetables',
      'description': 'Learn about healthy vegetables',
      'color': '#FF22C55E',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    final numbersId = await db.insert('categories', {
      'name': 'Numbers',
      'description': 'Learn to count and recognize numbers',
      'color': '#FFEAB308',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    final shapesId = await db.insert('categories', {
      'name': 'Shapes',
      'description': 'Learn about geometric shapes',
      'color': '#FF06B6D4',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 0,
    });

    // Closed / score-locked categories
    final transportationId = await db.insert('categories', {
      'name': 'Transportation',
      'description': 'Learn about different vehicles',
      'color': '#FF3B82F6',
      'is_active': 1,
      'required_score': 50,
      'is_premium': 0,
    });

    final colorsId = await db.insert('categories', {
      'name': 'Colors',
      'description': 'Learn about colors and shades',
      'color': '#FFEC4899',
      'is_active': 1,
      'required_score': 100,
      'is_premium': 0,
    });

    final emotionsId = await db.insert('categories', {
      'name': 'Emotions',
      'description': 'Learn about emotions and feelings',
      'color': '#FFD4AF37',
      'is_active': 1,
      'required_score': 30,
      'is_premium': 0,
    });

    // Premium categories (music and sports)
    final musicId = await db.insert('categories', {
      'name': 'Music',
      'description': 'Learn about musical instruments',
      'color': '#FFA855F7',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 1,
    });

    final sportsId = await db.insert('categories', {
      'name': 'Sports',
      'description': 'Learn about different sports',
      'color': '#FFF43F5E',
      'is_active': 1,
      'required_score': 0,
      'is_premium': 1,
    });

    // Seed sample questions and answers for each category so quizzes show up
    Future<void> insertQuestionWithAnswers(
      int categoryId,
      String questionText,
      List<Map<String, dynamic>> answers,
    ) async {
      final qId = await db.insert('questions', {
        'category_id': categoryId,
        'question_text': questionText,
        'image_url': null,
        'level': 1,
        'points': 10,
      });

      int order = 0;
      for (final ans in answers) {
        await db.insert('answers', {
          'question_id': qId,
          'answer_text': ans['text'],
          'is_correct': ans['is_correct'] ? 1 : 0,
          'display_order': order++,
        });
      }
    }

    // Animals
    await insertQuestionWithAnswers(animalsId, 'Which animal says "meow"?', [
      {'text': 'Cat', 'is_correct': true},
      {'text': 'Dog', 'is_correct': false},
      {'text': 'Cow', 'is_correct': false},
      {'text': 'Sheep', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(animalsId, 'Which is the fastest animal?', [
      {'text': 'Cheetah', 'is_correct': true},
      {'text': 'Lion', 'is_correct': false},
      {'text': 'Zebra', 'is_correct': false},
      {'text': 'Giraffe', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(animalsId, 'What sound does a duck make?', [
      {'text': 'Quack', 'is_correct': true},
      {'text': 'Moo', 'is_correct': false},
      {'text': 'Baa', 'is_correct': false},
      {'text': 'Oink', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(animalsId, 'Which animal has stripes?', [
      {'text': 'Zebra', 'is_correct': true},
      {'text': 'Giraffe', 'is_correct': false},
      {'text': 'Lion', 'is_correct': false},
      {'text': 'Elephant', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(animalsId, 'What do bees make?', [
      {'text': 'Honey', 'is_correct': true},
      {'text': 'Milk', 'is_correct': false},
      {'text': 'Eggs', 'is_correct': false},
      {'text': 'Wax', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      animalsId,
      'How many legs does a spider have?',
      [
        {'text': '8', 'is_correct': true},
        {'text': '6', 'is_correct': false},
        {'text': '4', 'is_correct': false},
        {'text': '10', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      animalsId,
      'Which animal is the king of the jungle?',
      [
        {'text': 'Lion', 'is_correct': true},
        {'text': 'Tiger', 'is_correct': false},
        {'text': 'Elephant', 'is_correct': false},
        {'text': 'Bear', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(animalsId, 'What is a baby dog called?', [
      {'text': 'Puppy', 'is_correct': true},
      {'text': 'Kitten', 'is_correct': false},
      {'text': 'Calf', 'is_correct': false},
      {'text': 'Chick', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      animalsId,
      'Which animal lives in water and lays eggs?',
      [
        {'text': 'Fish', 'is_correct': true},
        {'text': 'Duck', 'is_correct': false},
        {'text': 'Penguin', 'is_correct': false},
        {'text': 'Crocodile', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(animalsId, 'What color is a flamingo?', [
      {'text': 'Pink', 'is_correct': true},
      {'text': 'Red', 'is_correct': false},
      {'text': 'White', 'is_correct': false},
      {'text': 'Yellow', 'is_correct': false},
    ]);

    // Fruits
    await insertQuestionWithAnswers(
      fruitsId,
      'Which of these is a citrus fruit?',
      [
        {'text': 'Orange', 'is_correct': true},
        {'text': 'Banana', 'is_correct': false},
        {'text': 'Apple', 'is_correct': false},
        {'text': 'Grape', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(fruitsId, 'Which fruit is yellow?', [
      {'text': 'Banana', 'is_correct': true},
      {'text': 'Apple', 'is_correct': false},
      {'text': 'Orange', 'is_correct': false},
      {'text': 'Grape', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      fruitsId,
      'What fruit is red and grows on trees?',
      [
        {'text': 'Apple', 'is_correct': true},
        {'text': 'Banana', 'is_correct': false},
        {'text': 'Lemon', 'is_correct': false},
        {'text': 'Lime', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(fruitsId, 'Which fruit grows in bunches?', [
      {'text': 'Grapes', 'is_correct': true},
      {'text': 'Apple', 'is_correct': false},
      {'text': 'Pear', 'is_correct': false},
      {'text': 'Peach', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      fruitsId,
      'What is a small round red fruit?',
      [
        {'text': 'Strawberry', 'is_correct': true},
        {'text': 'Blueberry', 'is_correct': false},
        {'text': 'Raspberry', 'is_correct': false},
        {'text': 'Blackberry', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      fruitsId,
      'Which fruit is tropical and has a crown?',
      [
        {'text': 'Pineapple', 'is_correct': true},
        {'text': 'Papaya', 'is_correct': false},
        {'text': 'Mango', 'is_correct': false},
        {'text': 'Coconut', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      fruitsId,
      'What color is a ripe blueberry?',
      [
        {'text': 'Blue', 'is_correct': true},
        {'text': 'Red', 'is_correct': false},
        {'text': 'Purple', 'is_correct': false},
        {'text': 'Black', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      fruitsId,
      'Which fruit looks like a tiny orange?',
      [
        {'text': 'Tangerine', 'is_correct': true},
        {'text': 'Lime', 'is_correct': false},
        {'text': 'Lemon', 'is_correct': false},
        {'text': 'Grapefruit', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      fruitsId,
      'What is a sweet yellow tropical fruit?',
      [
        {'text': 'Mango', 'is_correct': true},
        {'text': 'Papaya', 'is_correct': false},
        {'text': 'Guava', 'is_correct': false},
        {'text': 'Passion fruit', 'is_correct': false},
      ],
    );

    // Vegetables
    await insertQuestionWithAnswers(vegetablesId, 'Which is a vegetable?', [
      {'text': 'Carrot', 'is_correct': true},
      {'text': 'Strawberry', 'is_correct': false},
      {'text': 'Mango', 'is_correct': false},
      {'text': 'Orange', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      vegetablesId,
      'Which vegetable is orange?',
      [
        {'text': 'Carrot', 'is_correct': true},
        {'text': 'Pea', 'is_correct': false},
        {'text': 'Corn', 'is_correct': false},
        {'text': 'Bean', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'What vegetable grows underground?',
      [
        {'text': 'Potato', 'is_correct': true},
        {'text': 'Tomato', 'is_correct': false},
        {'text': 'Lettuce', 'is_correct': false},
        {'text': 'Cucumber', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'Which is a leafy green vegetable?',
      [
        {'text': 'Spinach', 'is_correct': true},
        {'text': 'Carrot', 'is_correct': false},
        {'text': 'Onion', 'is_correct': false},
        {'text': 'Pepper', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'What vegetable makes you cry?',
      [
        {'text': 'Onion', 'is_correct': true},
        {'text': 'Garlic', 'is_correct': false},
        {'text': 'Leek', 'is_correct': false},
        {'text': 'Shallot', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'Which vegetable is red and round?',
      [
        {'text': 'Tomato', 'is_correct': true},
        {'text': 'Pepper', 'is_correct': false},
        {'text': 'Radish', 'is_correct': false},
        {'text': 'Beet', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'What vegetable has florets?',
      [
        {'text': 'Broccoli', 'is_correct': true},
        {'text': 'Lettuce', 'is_correct': false},
        {'text': 'Carrot', 'is_correct': false},
        {'text': 'Cucumber', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'Which vegetable is long and green?',
      [
        {'text': 'Cucumber', 'is_correct': true},
        {'text': 'Zucchini', 'is_correct': false},
        {'text': 'Bean', 'is_correct': false},
        {'text': 'Pea', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      vegetablesId,
      'What vegetable grows in pods?',
      [
        {'text': 'Pea', 'is_correct': true},
        {'text': 'Carrot', 'is_correct': false},
        {'text': 'Potato', 'is_correct': false},
        {'text': 'Turnip', 'is_correct': false},
      ],
    );

    // Numbers
    await insertQuestionWithAnswers(numbersId, 'What number comes after 2?', [
      {'text': '3', 'is_correct': true},
      {'text': '1', 'is_correct': false},
      {'text': '4', 'is_correct': false},
      {'text': '5', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(numbersId, 'What is 1 + 1?', [
      {'text': '2', 'is_correct': true},
      {'text': '1', 'is_correct': false},
      {'text': '3', 'is_correct': false},
      {'text': '4', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      numbersId,
      'Which number is bigger: 5 or 3?',
      [
        {'text': '5', 'is_correct': true},
        {'text': '3', 'is_correct': false},
        {'text': 'They are equal', 'is_correct': false},
        {'text': 'None', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(numbersId, 'What number comes before 5?', [
      {'text': '4', 'is_correct': true},
      {'text': '5', 'is_correct': false},
      {'text': '6', 'is_correct': false},
      {'text': '3', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      numbersId,
      'How many fingers on one hand?',
      [
        {'text': '5', 'is_correct': true},
        {'text': '4', 'is_correct': false},
        {'text': '6', 'is_correct': false},
        {'text': '10', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(numbersId, 'What is 2 + 3?', [
      {'text': '5', 'is_correct': true},
      {'text': '4', 'is_correct': false},
      {'text': '6', 'is_correct': false},
      {'text': '3', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      numbersId,
      'How many sides does a triangle have?',
      [
        {'text': '3', 'is_correct': true},
        {'text': '4', 'is_correct': false},
        {'text': '2', 'is_correct': false},
        {'text': '5', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(numbersId, 'What comes after 7?', [
      {'text': '8', 'is_correct': true},
      {'text': '7', 'is_correct': false},
      {'text': '9', 'is_correct': false},
      {'text': '6', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      numbersId,
      'Count the fingers: how many is 2 hands?',
      [
        {'text': '10', 'is_correct': true},
        {'text': '5', 'is_correct': false},
        {'text': '8', 'is_correct': false},
        {'text': '12', 'is_correct': false},
      ],
    );

    // Shapes
    await insertQuestionWithAnswers(
      shapesId,
      'Which shape has 4 equal sides?',
      [
        {'text': 'Square', 'is_correct': true},
        {'text': 'Triangle', 'is_correct': false},
        {'text': 'Circle', 'is_correct': false},
        {'text': 'Rectangle', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(shapesId, 'Which shape is round?', [
      {'text': 'Circle', 'is_correct': true},
      {'text': 'Square', 'is_correct': false},
      {'text': 'Triangle', 'is_correct': false},
      {'text': 'Rectangle', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      shapesId,
      'How many sides does a circle have?',
      [
        {'text': 'None', 'is_correct': true},
        {'text': '1', 'is_correct': false},
        {'text': '2', 'is_correct': false},
        {'text': '4', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(shapesId, 'Which shape has 3 sides?', [
      {'text': 'Triangle', 'is_correct': true},
      {'text': 'Square', 'is_correct': false},
      {'text': 'Circle', 'is_correct': false},
      {'text': 'Pentagon', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      shapesId,
      'A rectangle is longer than it is tall, true or false?',
      [
        {'text': 'True', 'is_correct': true},
        {'text': 'False', 'is_correct': false},
        {'text': 'Sometimes', 'is_correct': false},
        {'text': 'Never', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      shapesId,
      'How many corners does a triangle have?',
      [
        {'text': '3', 'is_correct': true},
        {'text': '2', 'is_correct': false},
        {'text': '4', 'is_correct': false},
        {'text': '5', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      shapesId,
      'Which shape looks like a star?',
      [
        {'text': 'Star', 'is_correct': true},
        {'text': 'Circle', 'is_correct': false},
        {'text': 'Square', 'is_correct': false},
        {'text': 'Triangle', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(shapesId, 'What shape is a stop sign?', [
      {'text': 'Octagon', 'is_correct': true},
      {'text': 'Square', 'is_correct': false},
      {'text': 'Pentagon', 'is_correct': false},
      {'text': 'Hexagon', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      shapesId,
      'A diamond shape has how many sides?',
      [
        {'text': '4', 'is_correct': true},
        {'text': '3', 'is_correct': false},
        {'text': '5', 'is_correct': false},
        {'text': '6', 'is_correct': false},
      ],
    );

    // Transportation (closed)
    await insertQuestionWithAnswers(transportationId, 'Which vehicle flies?', [
      {'text': 'Airplane', 'is_correct': true},
      {'text': 'Car', 'is_correct': false},
      {'text': 'Boat', 'is_correct': false},
      {'text': 'Bicycle', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      transportationId,
      'Which vehicle is used on water?',
      [
        {'text': 'Boat', 'is_correct': true},
        {'text': 'Car', 'is_correct': false},
        {'text': 'Train', 'is_correct': false},
        {'text': 'Bus', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'What vehicle runs on train tracks?',
      [
        {'text': 'Train', 'is_correct': true},
        {'text': 'Car', 'is_correct': false},
        {'text': 'Bus', 'is_correct': false},
        {'text': 'Bike', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'Which vehicle has two wheels?',
      [
        {'text': 'Bicycle', 'is_correct': true},
        {'text': 'Car', 'is_correct': false},
        {'text': 'Bus', 'is_correct': false},
        {'text': 'Truck', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'What is a person who drives a bus called?',
      [
        {'text': 'Bus driver', 'is_correct': true},
        {'text': 'Pilot', 'is_correct': false},
        {'text': 'Captain', 'is_correct': false},
        {'text': 'Engineer', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'Which vehicle carries lots of people?',
      [
        {'text': 'Bus', 'is_correct': true},
        {'text': 'Car', 'is_correct': false},
        {'text': 'Bike', 'is_correct': false},
        {'text': 'Scooter', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'What vehicle has a big truck bed?',
      [
        {'text': 'Pickup truck', 'is_correct': true},
        {'text': 'Car', 'is_correct': false},
        {'text': 'Van', 'is_correct': false},
        {'text': 'Bus', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'Which vehicle needs gas to run?',
      [
        {'text': 'Car', 'is_correct': true},
        {'text': 'Bicycle', 'is_correct': false},
        {'text': 'Skateboard', 'is_correct': false},
        {'text': 'Scooter', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      transportationId,
      'What vehicle is used for emergency help?',
      [
        {'text': 'Ambulance', 'is_correct': true},
        {'text': 'Taxi', 'is_correct': false},
        {'text': 'Bus', 'is_correct': false},
        {'text': 'Car', 'is_correct': false},
      ],
    );

    // Colors (closed)
    await insertQuestionWithAnswers(
      colorsId,
      'What color do you get by mixing red and blue?',
      [
        {'text': 'Purple', 'is_correct': true},
        {'text': 'Green', 'is_correct': false},
        {'text': 'Orange', 'is_correct': false},
        {'text': 'Brown', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      colorsId,
      'What color is the sky on a clear day?',
      [
        {'text': 'Blue', 'is_correct': true},
        {'text': 'Green', 'is_correct': false},
        {'text': 'Pink', 'is_correct': false},
        {'text': 'Yellow', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(colorsId, 'What color is grass?', [
      {'text': 'Green', 'is_correct': true},
      {'text': 'Blue', 'is_correct': false},
      {'text': 'Brown', 'is_correct': false},
      {'text': 'Yellow', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(colorsId, 'What color is a ripe tomato?', [
      {'text': 'Red', 'is_correct': true},
      {'text': 'Green', 'is_correct': false},
      {'text': 'Yellow', 'is_correct': false},
      {'text': 'Orange', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(colorsId, 'What color is snow?', [
      {'text': 'White', 'is_correct': true},
      {'text': 'Blue', 'is_correct': false},
      {'text': 'Gray', 'is_correct': false},
      {'text': 'Clear', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(colorsId, 'What color is a banana?', [
      {'text': 'Yellow', 'is_correct': true},
      {'text': 'Green', 'is_correct': false},
      {'text': 'Orange', 'is_correct': false},
      {'text': 'Brown', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      colorsId,
      'What color do you get by mixing red and yellow?',
      [
        {'text': 'Orange', 'is_correct': true},
        {'text': 'Green', 'is_correct': false},
        {'text': 'Purple', 'is_correct': false},
        {'text': 'Brown', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      colorsId,
      'What color do you get by mixing blue and yellow?',
      [
        {'text': 'Green', 'is_correct': true},
        {'text': 'Purple', 'is_correct': false},
        {'text': 'Orange', 'is_correct': false},
        {'text': 'Brown', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(colorsId, 'What color is a fire truck?', [
      {'text': 'Red', 'is_correct': true},
      {'text': 'Blue', 'is_correct': false},
      {'text': 'Yellow', 'is_correct': false},
      {'text': 'White', 'is_correct': false},
    ]);

    // Emotions (closed)
    await insertQuestionWithAnswers(
      emotionsId,
      'Which emotion shows happiness?',
      [
        {'text': 'Smiling', 'is_correct': true},
        {'text': 'Crying', 'is_correct': false},
        {'text': 'Angry', 'is_correct': false},
        {'text': 'Scared', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      emotionsId,
      'Which emotion means you are sad?',
      [
        {'text': 'Sad', 'is_correct': true},
        {'text': 'Happy', 'is_correct': false},
        {'text': 'Angry', 'is_correct': false},
        {'text': 'Scared', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      emotionsId,
      'What emotion do you feel when something is funny?',
      [
        {'text': 'Laughing', 'is_correct': true},
        {'text': 'Crying', 'is_correct': false},
        {'text': 'Angry', 'is_correct': false},
        {'text': 'Scared', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(emotionsId, 'Which emotion shows fear?', [
      {'text': 'Scared', 'is_correct': true},
      {'text': 'Happy', 'is_correct': false},
      {'text': 'Calm', 'is_correct': false},
      {'text': 'Confident', 'is_correct': false},
    ]);
    await insertQuestionWithAnswers(
      emotionsId,
      'What emotion do you have when you are not calm?',
      [
        {'text': 'Angry', 'is_correct': true},
        {'text': 'Happy', 'is_correct': false},
        {'text': 'Sleepy', 'is_correct': false},
        {'text': 'Bored', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      emotionsId,
      'Which emotion is opposite to sad?',
      [
        {'text': 'Happy', 'is_correct': true},
        {'text': 'Angry', 'is_correct': false},
        {'text': 'Scared', 'is_correct': false},
        {'text': 'Tired', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      emotionsId,
      'What emotion do you have when something hurts?',
      [
        {'text': 'Pain', 'is_correct': true},
        {'text': 'Happy', 'is_correct': false},
        {'text': 'Calm', 'is_correct': false},
        {'text': 'Excited', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      emotionsId,
      'Which emotion means you feel well?',
      [
        {'text': 'Good', 'is_correct': true},
        {'text': 'Bad', 'is_correct': false},
        {'text': 'Tired', 'is_correct': false},
        {'text': 'Bored', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      emotionsId,
      'What do you feel when you see something exciting?',
      [
        {'text': 'Excited', 'is_correct': true},
        {'text': 'Bored', 'is_correct': false},
        {'text': 'Tired', 'is_correct': false},
        {'text': 'Sad', 'is_correct': false},
      ],
    );

    // Music (premium)
    await insertQuestionWithAnswers(
      musicId,
      'Which instrument has keys and many strings inside?',
      [
        {'text': 'Piano', 'is_correct': true},
        {'text': 'Drum', 'is_correct': false},
        {'text': 'Flute', 'is_correct': false},
        {'text': 'Guitar', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'Which instrument is blown like a whistle?',
      [
        {'text': 'Flute', 'is_correct': true},
        {'text': 'Drum', 'is_correct': false},
        {'text': 'Guitar', 'is_correct': false},
        {'text': 'Violin', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'What do you hit to make music with a drum?',
      [
        {'text': 'Drumsticks', 'is_correct': true},
        {'text': 'Mallets', 'is_correct': false},
        {'text': 'Hands', 'is_correct': false},
        {'text': 'Brushes', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'Which instrument has strings and is played with a bow?',
      [
        {'text': 'Violin', 'is_correct': true},
        {'text': 'Guitar', 'is_correct': false},
        {'text': 'Harp', 'is_correct': false},
        {'text': 'Lute', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'What instrument looks like a small harp?',
      [
        {'text': 'Ukulele', 'is_correct': true},
        {'text': 'Mandolin', 'is_correct': false},
        {'text': 'Banjo', 'is_correct': false},
        {'text': 'Lute', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'Which instrument is played by pressing keys?',
      [
        {'text': 'Keyboard', 'is_correct': true},
        {'text': 'Violin', 'is_correct': false},
        {'text': 'Guitar', 'is_correct': false},
        {'text': 'Trumpet', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'What instrument is shiny and loud?',
      [
        {'text': 'Trumpet', 'is_correct': true},
        {'text': 'Flute', 'is_correct': false},
        {'text': 'Clarinet', 'is_correct': false},
        {'text': 'Saxophone', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'How many strings does a guitar usually have?',
      [
        {'text': '6', 'is_correct': true},
        {'text': '4', 'is_correct': false},
        {'text': '8', 'is_correct': false},
        {'text': '12', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      musicId,
      'Which instrument sounds like a cat?',
      [
        {'text': 'Saxophone', 'is_correct': true},
        {'text': 'Trumpet', 'is_correct': false},
        {'text': 'Flute', 'is_correct': false},
        {'text': 'Clarinet', 'is_correct': false},
      ],
    );

    // Sports (premium)
    await insertQuestionWithAnswers(
      sportsId,
      'Which sport uses a hoop and ball?',
      [
        {'text': 'Basketball', 'is_correct': true},
        {'text': 'Soccer', 'is_correct': false},
        {'text': 'Tennis', 'is_correct': false},
        {'text': 'Cricket', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'Which sport uses a ball and a racket?',
      [
        {'text': 'Tennis', 'is_correct': true},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Soccer', 'is_correct': false},
        {'text': 'Volleyball', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'Which sport is played on grass with a ball?',
      [
        {'text': 'Soccer', 'is_correct': true},
        {'text': 'Tennis', 'is_correct': false},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Baseball', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'What sport uses a bat and a ball?',
      [
        {'text': 'Baseball', 'is_correct': true},
        {'text': 'Tennis', 'is_correct': false},
        {'text': 'Soccer', 'is_correct': false},
        {'text': 'Golf', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'Which sport is played in a pool?',
      [
        {'text': 'Swimming', 'is_correct': true},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Soccer', 'is_correct': false},
        {'text': 'Tennis', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'What sport involves running very fast?',
      [
        {'text': 'Track and field', 'is_correct': true},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Tennis', 'is_correct': false},
        {'text': 'Golf', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'Which sport involves a net over grass?',
      [
        {'text': 'Volleyball', 'is_correct': true},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Tennis', 'is_correct': false},
        {'text': 'Soccer', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'What sport uses an oval ball and a field?',
      [
        {'text': 'American Football', 'is_correct': true},
        {'text': 'Soccer', 'is_correct': false},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Baseball', 'is_correct': false},
      ],
    );
    await insertQuestionWithAnswers(
      sportsId,
      'Which sport involves jumping on ice?',
      [
        {'text': 'Ice skating', 'is_correct': true},
        {'text': 'Hockey', 'is_correct': false},
        {'text': 'Basketball', 'is_correct': false},
        {'text': 'Tennis', 'is_correct': false},
      ],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  /// Seed database if questions table is empty (ensures questions exist even on upgrades).
  Future<void> seedFromAssetsIfEmpty() async {
    final db = await database;

    // Check if questions already exist - if they do, we don't need to seed
    final questionCountRes = await db.rawQuery(
      'SELECT COUNT(*) as count FROM questions',
    );
    final questionCount = questionCountRes.first['count'] as int? ?? 0;
    if (questionCount > 0) return; // questions already exist, no need to seed

    // Check if categories exist - if not, we need to seed everything
    final categoryCountRes = await db.rawQuery(
      'SELECT COUNT(*) as count FROM categories',
    );
    final categoryCount = categoryCountRes.first['count'] as int? ?? 0;

    try {
      // If no categories, we need to seed from assets
      if (categoryCount == 0) {
        final categoriesJson = await rootBundle.loadString(
          'assets/seeds/categories.json',
        );
        final questionsJson = await rootBundle.loadString(
          'assets/seeds/questions.json',
        );
        final answersJson = await rootBundle.loadString(
          'assets/seeds/answers.json',
        );

        final List<dynamic> categoriesList = json.decode(categoriesJson);
        final List<dynamic> questionsList = json.decode(questionsJson);
        final List<dynamic> answersList = json.decode(answersJson);

        // Insert categories and map names to ids
        final Map<String, int> catIds = {};
        for (final c in categoriesList) {
          final id = await db.insert('categories', {
            'name': c['name'],
            'description': c['description'],
            'image_url': c['image_url'],
            'color': c['color'],
            'is_active': c['is_active'] ?? 1,
            'required_score': c['required_score'] ?? 0,
            'is_premium': c['is_premium'] ?? 0,
          });
          catIds[c['name']] = id;
        }

        // Helper to insert question with answers
        Future<void> insertQ(
          String categoryName,
          String questionText,
          List<dynamic> ansList,
        ) async {
          final catId = catIds[categoryName];
          if (catId == null) return;
          final qId = await db.insert('questions', {
            'category_id': catId,
            'question_text': questionText,
            'image_url': null,
            'level': 1,
            'points': 10,
          });
          int order = 0;
          for (final a in ansList) {
            await db.insert('answers', {
              'question_id': qId,
              'answer_text': a['text'],
              'is_correct': a['is_correct'] ? 1 : 0,
              'display_order': order++,
            });
          }
        }

        // Build a map from question text -> answers data from answersList for quick lookup
        final Map<String, dynamic> answersByQuestion = {};
        for (final a in answersList) {
          answersByQuestion[a['question_text']] = a;
        }

        // Insert questions
        for (final q in questionsList) {
          final categoryName = q['category_name'];
          final questionText = q['question_text'];
          final matchedAnswers = answersByQuestion[questionText];
          if (matchedAnswers != null && matchedAnswers['answers'] != null) {
            final List<dynamic> ansTexts = matchedAnswers['answers'];
            final int correctIndex = matchedAnswers['correct_index'] ?? 0;
            final List<dynamic> ansObjs = [];
            for (int i = 0; i < ansTexts.length; i++) {
              ansObjs.add({
                'text': ansTexts[i],
                'is_correct': i == correctIndex,
              });
            }
            await insertQ(categoryName, questionText, ansObjs);
          }
        }
      } else if (categoryCount > 0) {
        // Categories exist but no questions - get existing category IDs and seed questions into them
        final categoriesResult = await db.query(
          'categories',
          columns: ['id', 'name'],
        );
        final Map<String, int> catIds = {};
        for (final row in categoriesResult) {
          catIds[row['name'] as String] = row['id'] as int;
        }

        // Helper to insert question with answers
        Future<void> insertQ(
          String categoryName,
          String questionText,
          List<dynamic> ansList,
        ) async {
          final catId = catIds[categoryName];
          if (catId == null) return;
          final qId = await db.insert('questions', {
            'category_id': catId,
            'question_text': questionText,
            'image_url': null,
            'level': 1,
            'points': 10,
          });
          int order = 0;
          for (final a in ansList) {
            await db.insert('answers', {
              'question_id': qId,
              'answer_text': a['text'],
              'is_correct': a['is_correct'] ? 1 : 0,
              'display_order': order++,
            });
          }
        }

        try {
          final questionsJson = await rootBundle.loadString(
            'assets/seeds/questions.json',
          );
          final answersJson = await rootBundle.loadString(
            'assets/seeds/answers.json',
          );
          final List<dynamic> questionsList = json.decode(questionsJson);
          final List<dynamic> answersList = json.decode(answersJson);

          // Build a map from question text -> answers data
          final Map<String, dynamic> answersByQuestion = {};
          for (final a in answersList) {
            answersByQuestion[a['question_text']] = a;
          }

          // Insert questions
          for (final q in questionsList) {
            final categoryName = q['category_name'];
            final questionText = q['question_text'];
            final matchedAnswers = answersByQuestion[questionText];
            if (matchedAnswers != null && matchedAnswers['answers'] != null) {
              final List<dynamic> ansTexts = matchedAnswers['answers'];
              final int correctIndex = matchedAnswers['correct_index'] ?? 0;
              final List<dynamic> ansObjs = [];
              for (int i = 0; i < ansTexts.length; i++) {
                ansObjs.add({
                  'text': ansTexts[i],
                  'is_correct': i == correctIndex,
                });
              }
              await insertQ(categoryName, questionText, ansObjs);
            }
          }
        } catch (e) {
          debugPrint('Failed to seed questions from assets: ${e.toString()}');
        }
      }
    } catch (e) {
      // Ignore seeding errors but log debug
      debugPrint('DB seeding from assets failed: ${e.toString()}');
    }
  }
}
