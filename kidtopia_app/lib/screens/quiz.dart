import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int progress = 0;
  int total = 10;
  int score = 0;
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool answered = false;

  List<String> imagePaths = [
    'lib/assets/images/image1.jpeg',
    'lib/assets/images/image2.jpeg',
    'lib/assets/images/image3.jpeg',
    'lib/assets/images/image4.jpeg',
    'lib/assets/images/image5.jpeg',
    'lib/assets/images/image6.jpeg',
    'lib/assets/images/image7.jpeg',
    'lib/assets/images/image8.jpeg',
    'lib/assets/images/image9.jpeg',
    'lib/assets/images/image10.jpeg',
  ];

  List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'question': 'What do elephants use to drink water?',
      'answers': ['Trunk', 'Tail', 'Feet', 'Tusks'],
      'correct': 'Trunk',
    },
    {
      'id': 2,
      'question': 'Where do frogs usually live?',
      'answers': ['Desert', 'Ocean', 'Pond', 'Mountain'],
      'correct': 'Pond',
    },
    {
      'id': 3,
      'question': 'Where do penguins live?',
      'answers': ['North Pole', 'South Pole', 'Desert', 'Jungle'],
      'correct': 'South Pole',
    },
    {
      'id': 4,
      'question': 'What sound does a cat make?',
      'answers': ['Woof', 'Meow', 'Moo', 'Quack'],
      'correct': 'Meow',
    },
    {
      'id': 5,
      'question': 'What do cats like to chase?',
      'answers': ['Mice', 'Fish', 'Birds', 'Dogs'],
      'correct': 'Mice',
    },
    {
      'id': 6,
      'question': 'What is a lion known as?',
      'answers': [
        'King of the Jungle',
        'Fastest Animal',
        'Tallest Animal',
        'Small Cat',
      ],
      'correct': 'King of the Jungle',
    },
    {
      'id': 7,
      'question': 'What color is a typical fox?',
      'answers': ['Red', 'Blue', 'White', 'Green'],
      'correct': 'Red',
    },
    {
      'id': 8,
      'question': 'How many legs does a crab have?',
      'answers': ['4', '6', '8', '10'],
      'correct': '10',
    },
    {
      'id': 9,
      'question': 'Which of these is a loyal pet?',
      'answers': ['Cat', 'Dog', 'Fish', 'Snake'],
      'correct': 'Dog',
    },
    {
      'id': 10,
      'question': 'What do bees collect from flowers?',
      'answers': ['Honey', 'Nectar', 'Pollen', 'Water'],
      'correct': 'Nectar',
    },
  ];

  void selectAnswer(String answer) {
    if (!answered) {
      setState(() {
        selectedAnswer = answer;
      });
    }
  }

  void checkAnswerAndProceed() {
    setState(() {
      if (selectedAnswer == questions[currentQuestionIndex]['correct']) {
        score++;
      }
      answered = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        progress++;

        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          selectedAnswer = null;
          answered = false;
        } else {
          // Navigate to ScoreScreen when quiz is complete
          Navigator.pushReplacementNamed(context, '/score');
        }
      });
    });
  }

  Color getAnswerColor(String answer) {
    if (!answered) {
      return selectedAnswer == answer ? Colors.pinkAccent : Colors.white;
    }

    if (answer == questions[currentQuestionIndex]['correct']) {
      return Colors.green;
    } else if (answer == selectedAnswer) {
      return Colors.red;
    }
    return Colors.white;
  }

  Color getTextColor(String answer) {
    if (!answered) {
      return selectedAnswer == answer ? Colors.white : Colors.black;
    }

    if (answer == questions[currentQuestionIndex]['correct'] ||
        answer == selectedAnswer) {
      return Colors.white;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final currentAnswers =
        questions[currentQuestionIndex]['answers'] as List<String>;
    final currentQuestion =
        questions[currentQuestionIndex]['question'] as String;

    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 228, 104, 176),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$progress / $total',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress / 10,
            backgroundColor: Colors.grey.shade300,
            color: Colors.pinkAccent,
            minHeight: 6,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    currentQuestion,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    imagePaths[currentQuestionIndex],
                    fit: BoxFit.contain,
                    width: 250,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: currentAnswers.map((answer) {
                    final isSelected = selectedAnswer == answer;
                    return GestureDetector(
                      onTap: () => selectAnswer(answer),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: getAnswerColor(answer),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            answer,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: getTextColor(answer),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              if (selectedAnswer != null && !answered)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: checkAnswerAndProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Check Answer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
