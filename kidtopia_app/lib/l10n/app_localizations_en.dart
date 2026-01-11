// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get profile => 'Profile';

  @override
  String get guest => 'Guest';

  @override
  String get readyToPlay => 'Ready to Play?';

  @override
  String showUsPowers(String username) {
    return 'Show us your powers $username!';
  }

  @override
  String get letsGo => 'Let\'s Go';

  @override
  String get premiumRequired => 'Premium Required';

  @override
  String get unlockCategory =>
      'Unlock this category with Premium subscription!';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get getPremium => 'Get Premium';

  @override
  String get scoreRequired => 'Score Required';

  @override
  String needPoints(int requiredScore, String categoryName) {
    return 'You need $requiredScore points to unlock $categoryName!';
  }

  @override
  String earnMorePoints(int points) {
    return 'Earn $points more points.';
  }

  @override
  String get ok => 'OK';

  @override
  String get keepPlaying => 'Keep Playing';

  @override
  String get loadingCategories => 'Loading categories...';

  @override
  String get retry => 'Retry';

  @override
  String get noCategoriesYet => 'No Categories Yet';

  @override
  String get categoriesWillAppear =>
      'Categories will appear here once added to the database';

  @override
  String get refresh => 'Refresh';

  @override
  String ptsRequired(int points) {
    return '$points pts required';
  }

  @override
  String get premium => 'Premium';

  @override
  String get becomePro => 'Become a pro member';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String get freeMember => 'Free Member';

  @override
  String get logout => 'Logout';

  @override
  String get points => 'Points';

  @override
  String get bestGames => 'Best games';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get myScore => 'My score';

  @override
  String scorePoints(int score) {
    return '$score points';
  }

  @override
  String get paymentSettings => 'Payment settings';

  @override
  String get paymentComingSoon => 'Payment settings coming soon!';

  @override
  String get nowPremium => 'You are now a premium member!';

  @override
  String get loadingQuestions => 'Loading questions from database...';

  @override
  String get noQuestionsAvailable => 'No Questions Available';

  @override
  String get questionsNeeded =>
      'Questions need to be added to the database for this category.';

  @override
  String get chooseAnotherCategory => 'Choose Another Category';

  @override
  String get question => 'Question';

  @override
  String questionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String addPoints(int points) {
    return '+$points points';
  }

  @override
  String get noAnswersFound => 'No answers found for this question';

  @override
  String get checkAnswer => 'Check Answer';

  @override
  String correctAnswer(int points) {
    return 'Correct! +$points points';
  }

  @override
  String get wrongAnswer => 'Wrong answer!';

  @override
  String get chooseCategory => 'Choose Category';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get arabic => 'Arabic';

  @override
  String get scoreScreenTitle => 'Excellent!';

  @override
  String get greatJob => 'Great Job!';

  @override
  String get goodTry => 'Good Try!';

  @override
  String get keepPracticing => 'Keep Practicing!';

  @override
  String get pointsEarned => 'points';

  @override
  String get correct => 'Correct';

  @override
  String get totalScore => 'Total Score';

  @override
  String nextGameIn(int seconds) {
    return 'Next game in $seconds seconds...';
  }

  @override
  String get scoreToUnlock => 'Score 7+ to unlock a mini-game!';

  @override
  String get playAgain => 'Play Again';

  @override
  String get nextNow => 'Next Now';

  @override
  String get noReward => 'No Reward';

  @override
  String get goHome => 'Go Home';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get kidtopia => 'Kidtopia';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get letsPlayAgain => 'Let\'s play again!';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get letsGetStarted => 'Let\'s get you started!';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get createUsername => 'Create a username';

  @override
  String get createPassword => 'Create a password';

  @override
  String get reenterPassword => 'Re-enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get passwordResetSoon => 'Password reset coming soon!';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get pleaseEnterUsername => 'Please enter your username';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get usernameMinLength => 'Username must be at least 3 characters';

  @override
  String get passwordMinLength => 'Password must be at least 4 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get timesUp => 'Time\'s Up!';

  @override
  String get dontGiveUp => 'Don\'t give up!\nTry again! 💪';

  @override
  String get goodJobVictory => 'Good Job!';

  @override
  String get youSolvedGame => 'You solved the game!';

  @override
  String get youWin => '🎉 YOU WIN! 🎉';

  @override
  String get amazingMemory => 'Amazing Memory!';

  @override
  String get playAgainButton => '🔄 Play Again';

  @override
  String get homeButton => '🏠 Home';

  @override
  String get initializationError => 'Initialization Error';

  @override
  String get learningMadeFun => 'Learning made fun!';

  @override
  String get initializing => 'Initializing...';

  @override
  String get level => 'Level';

  @override
  String get levelComplete => 'Level Complete!';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get petCareGame => 'Pet Care Game';

  @override
  String get time => 'Time';

  @override
  String get happiness => 'Happiness';

  @override
  String get fullness => 'Fullness';

  @override
  String get play => 'Play';

  @override
  String get pet => 'Pet';

  @override
  String get tryAgain => 'Try Again!';

  @override
  String get startGame => 'Start Game!';

  @override
  String get ohNo => 'Oh No!';

  @override
  String get petGameOverMessage =>
      'Your pet got too sad or hungry!\nTry to keep both bars above 90%!';

  @override
  String get feedYourPet => 'Feed Your Pet';

  @override
  String get chooseYourPet => 'Choose Your Pet';

  @override
  String get howToWin => 'How to Win:';

  @override
  String get petGameInstructions =>
      '🎯 Goal: Keep your pet happy and fed for 60 seconds!\n\n✅ Win: Both bars stay above 90%\n❌ Lose: Any bar reaches 0%\n\n💡 Tips:\n• Feed often to keep fullness up\n• Play and pet for happiness\n• Playing makes pet hungry!\n• Different foods give different boosts';

  @override
  String get rainbowMonsterCollector => 'Rainbow Monster Collector';

  @override
  String get customizeGame => 'Customize Your Game!';

  @override
  String get chooseMonsterType => 'Choose Monster Type:';

  @override
  String get chooseBackground => 'Choose Background:';

  @override
  String get howToPlay => 'How to Play:';

  @override
  String monsterGameGoal(Object score) {
    return '🎯 Goal: Score $score points to win!';
  }

  @override
  String get monsterGameInstructions =>
      '👆 Tap bouncing monsters to catch them (10 points each).\n⏰ You have 60 seconds. Good luck! 🎈';

  @override
  String get waterSortGame => 'Water Sort Game';

  @override
  String get waterSortMessage => 'Don\'t let them stay empty! 💧';

  @override
  String get memoryGame => 'Memory Game';

  @override
  String get foodMemoryGame => 'Food Memory Game';

  @override
  String get skip => 'Skip';

  @override
  String get quizReminders => 'Quiz Reminders';

  @override
  String get quizRemindersDescription =>
      'Notifications to remind users to play quiz';

  @override
  String get periodicReminderScheduled =>
      'Periodic reminder scheduled (every 2 days)';

  @override
  String get allRemindersScheduled => 'All reminders scheduled';

  @override
  String get allReminersCancelled => 'All reminders cancelled';

  @override
  String reminderCancelled(String taskName) {
    return 'Reminder $taskName cancelled';
  }

  @override
  String get timeToPlay => '🎮 Time to Play!';

  @override
  String get timeToPlayBody =>
      'Hey! Ready for some fun quizzes? Let\'s keep learning! 🌟';

  @override
  String backgroundTaskExecuted(String taskName) {
    return 'Background task executed: $taskName';
  }

  @override
  String get notificationSentSuccessfully => 'Notification sent successfully';

  @override
  String errorShowingNotification(String error) {
    return 'Error showing notification: $error';
  }

  @override
  String iOSNotificationPermission(String permission) {
    return 'iOS notification permission: $permission';
  }

  @override
  String notificationTapped(String payload) {
    return 'Notification tapped: $payload';
  }

  @override
  String get error => 'Error';

  @override
  String get failedToUpgrade => 'Failed to upgrade. Please try again.';

  @override
  String get unlockAllFeatures => 'Unlock All Features!';

  @override
  String get joinThousandsOfPremiumUsers => 'Join thousands of premium users';

  @override
  String get whatYouGet => 'What You Get:';

  @override
  String get processing => 'Processing...';

  @override
  String get securePayment => 'Secure Payment • 100% Safe';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get enjoyUnlimitedAccess => 'Enjoy unlimited access to all features!';

  @override
  String get accessToMusicSportsCategories =>
      'Access to Music & Sports categories';

  @override
  String get unlimitedQuizAttempts => 'Unlimited quiz attempts';

  @override
  String get adFreeExperience => 'Ad-free experience';

  @override
  String get priorityCustomerSupport => 'Priority customer support';

  @override
  String get allFutureUpdatesIncluded => 'All future updates included';
}
