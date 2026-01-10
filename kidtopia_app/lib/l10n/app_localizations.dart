import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @readyToPlay.
  ///
  /// In en, this message translates to:
  /// **'Ready to Play?'**
  String get readyToPlay;

  /// No description provided for @showUsPowers.
  ///
  /// In en, this message translates to:
  /// **'Show us your powers {username}!'**
  String showUsPowers(String username);

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get letsGo;

  /// No description provided for @premiumRequired.
  ///
  /// In en, this message translates to:
  /// **'Premium Required'**
  String get premiumRequired;

  /// No description provided for @unlockCategory.
  ///
  /// In en, this message translates to:
  /// **'Unlock this category with Premium subscription!'**
  String get unlockCategory;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @getPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get getPremium;

  /// No description provided for @scoreRequired.
  ///
  /// In en, this message translates to:
  /// **'Score Required'**
  String get scoreRequired;

  /// No description provided for @needPoints.
  ///
  /// In en, this message translates to:
  /// **'You need {requiredScore} points to unlock {categoryName}!'**
  String needPoints(int requiredScore, String categoryName);

  /// No description provided for @earnMorePoints.
  ///
  /// In en, this message translates to:
  /// **'Earn {points} more points.'**
  String earnMorePoints(int points);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @keepPlaying.
  ///
  /// In en, this message translates to:
  /// **'Keep Playing'**
  String get keepPlaying;

  /// No description provided for @loadingCategories.
  ///
  /// In en, this message translates to:
  /// **'Loading categories...'**
  String get loadingCategories;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No Categories Yet'**
  String get noCategoriesYet;

  /// No description provided for @categoriesWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Categories will appear here once added to the database'**
  String get categoriesWillAppear;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @ptsRequired.
  ///
  /// In en, this message translates to:
  /// **'{points} pts required'**
  String ptsRequired(int points);

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @becomePro.
  ///
  /// In en, this message translates to:
  /// **'Become a pro member'**
  String get becomePro;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @freeMember.
  ///
  /// In en, this message translates to:
  /// **'Free Member'**
  String get freeMember;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @bestGames.
  ///
  /// In en, this message translates to:
  /// **'Best games'**
  String get bestGames;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @myScore.
  ///
  /// In en, this message translates to:
  /// **'My score'**
  String get myScore;

  /// No description provided for @scorePoints.
  ///
  /// In en, this message translates to:
  /// **'{score} points'**
  String scorePoints(int score);

  /// No description provided for @paymentSettings.
  ///
  /// In en, this message translates to:
  /// **'Payment settings'**
  String get paymentSettings;

  /// No description provided for @paymentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment settings coming soon!'**
  String get paymentComingSoon;

  /// No description provided for @nowPremium.
  ///
  /// In en, this message translates to:
  /// **'You are now a premium member!'**
  String get nowPremium;

  /// No description provided for @loadingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Loading questions from database...'**
  String get loadingQuestions;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Questions Available'**
  String get noQuestionsAvailable;

  /// No description provided for @questionsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Questions need to be added to the database for this category.'**
  String get questionsNeeded;

  /// No description provided for @chooseAnotherCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose Another Category'**
  String get chooseAnotherCategory;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @questionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionOf(int current, int total);

  /// No description provided for @addPoints.
  ///
  /// In en, this message translates to:
  /// **'+{points} points'**
  String addPoints(int points);

  /// No description provided for @noAnswersFound.
  ///
  /// In en, this message translates to:
  /// **'No answers found for this question'**
  String get noAnswersFound;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get checkAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct! +{points} points'**
  String correctAnswer(int points);

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer!'**
  String get wrongAnswer;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose Category'**
  String get chooseCategory;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @scoreScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Excellent!'**
  String get scoreScreenTitle;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// No description provided for @goodTry.
  ///
  /// In en, this message translates to:
  /// **'Good Try!'**
  String get goodTry;

  /// No description provided for @keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing!'**
  String get keepPracticing;

  /// No description provided for @pointsEarned.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get pointsEarned;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @totalScore.
  ///
  /// In en, this message translates to:
  /// **'Total Score'**
  String get totalScore;

  /// No description provided for @nextGameIn.
  ///
  /// In en, this message translates to:
  /// **'Next game in {seconds} seconds...'**
  String nextGameIn(int seconds);

  /// No description provided for @scoreToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Score 7+ to unlock a mini-game!'**
  String get scoreToUnlock;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @nextNow.
  ///
  /// In en, this message translates to:
  /// **'Next Now'**
  String get nextNow;

  /// No description provided for @noReward.
  ///
  /// In en, this message translates to:
  /// **'No Reward'**
  String get noReward;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @kidtopia.
  ///
  /// In en, this message translates to:
  /// **'Kidtopia'**
  String get kidtopia;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @letsPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Let\'s play again!'**
  String get letsPlayAgain;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started!'**
  String get letsGetStarted;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @createUsername.
  ///
  /// In en, this message translates to:
  /// **'Create a username'**
  String get createUsername;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reenterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @passwordResetSoon.
  ///
  /// In en, this message translates to:
  /// **'Password reset coming soon!'**
  String get passwordResetSoon;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterUsername;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get usernameMinLength;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 4 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @timesUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get timesUp;

  /// No description provided for @dontGiveUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t give up!\nTry again! 💪'**
  String get dontGiveUp;

  /// No description provided for @goodJobVictory.
  ///
  /// In en, this message translates to:
  /// **'Good Job!'**
  String get goodJobVictory;

  /// No description provided for @youSolvedGame.
  ///
  /// In en, this message translates to:
  /// **'You solved the game!'**
  String get youSolvedGame;

  /// No description provided for @youWin.
  ///
  /// In en, this message translates to:
  /// **'🎉 YOU WIN! 🎉'**
  String get youWin;

  /// No description provided for @amazingMemory.
  ///
  /// In en, this message translates to:
  /// **'Amazing Memory!'**
  String get amazingMemory;

  /// No description provided for @playAgainButton.
  ///
  /// In en, this message translates to:
  /// **'🔄 Play Again'**
  String get playAgainButton;

  /// No description provided for @homeButton.
  ///
  /// In en, this message translates to:
  /// **'🏠 Home'**
  String get homeButton;

  /// No description provided for @initializationError.
  ///
  /// In en, this message translates to:
  /// **'Initialization Error'**
  String get initializationError;

  /// No description provided for @learningMadeFun.
  ///
  /// In en, this message translates to:
  /// **'Learning made fun!'**
  String get learningMadeFun;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @levelComplete.
  ///
  /// In en, this message translates to:
  /// **'Level Complete!'**
  String get levelComplete;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @petCareGame.
  ///
  /// In en, this message translates to:
  /// **'Pet Care Game'**
  String get petCareGame;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @happiness.
  ///
  /// In en, this message translates to:
  /// **'Happiness'**
  String get happiness;

  /// No description provided for @fullness.
  ///
  /// In en, this message translates to:
  /// **'Fullness'**
  String get fullness;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pet.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get pet;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again!'**
  String get tryAgain;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game!'**
  String get startGame;

  /// No description provided for @ohNo.
  ///
  /// In en, this message translates to:
  /// **'Oh No!'**
  String get ohNo;

  /// No description provided for @petGameOverMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pet got too sad or hungry!\nTry to keep both bars above 90%!'**
  String get petGameOverMessage;

  /// No description provided for @feedYourPet.
  ///
  /// In en, this message translates to:
  /// **'Feed Your Pet'**
  String get feedYourPet;

  /// No description provided for @chooseYourPet.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Pet'**
  String get chooseYourPet;

  /// No description provided for @howToWin.
  ///
  /// In en, this message translates to:
  /// **'How to Win:'**
  String get howToWin;

  /// No description provided for @petGameInstructions.
  ///
  /// In en, this message translates to:
  /// **'🎯 Goal: Keep your pet happy and fed for 60 seconds!\n\n✅ Win: Both bars stay above 90%\n❌ Lose: Any bar reaches 0%\n\n💡 Tips:\n• Feed often to keep fullness up\n• Play and pet for happiness\n• Playing makes pet hungry!\n• Different foods give different boosts'**
  String get petGameInstructions;

  /// No description provided for @rainbowMonsterCollector.
  ///
  /// In en, this message translates to:
  /// **'Rainbow Monster Collector'**
  String get rainbowMonsterCollector;

  /// No description provided for @customizeGame.
  ///
  /// In en, this message translates to:
  /// **'Customize Your Game!'**
  String get customizeGame;

  /// No description provided for @chooseMonsterType.
  ///
  /// In en, this message translates to:
  /// **'Choose Monster Type:'**
  String get chooseMonsterType;

  /// No description provided for @chooseBackground.
  ///
  /// In en, this message translates to:
  /// **'Choose Background:'**
  String get chooseBackground;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to Play:'**
  String get howToPlay;

  /// No description provided for @monsterGameGoal.
  ///
  /// In en, this message translates to:
  /// **'🎯 Goal: Score {score} points to win!'**
  String monsterGameGoal(Object score);

  /// No description provided for @monsterGameInstructions.
  ///
  /// In en, this message translates to:
  /// **'👆 Tap bouncing monsters to catch them (10 points each).\n⏰ You have 60 seconds. Good luck! 🎈'**
  String get monsterGameInstructions;

  /// No description provided for @waterSortGame.
  ///
  /// In en, this message translates to:
  /// **'Water Sort Game'**
  String get waterSortGame;

  /// No description provided for @waterSortMessage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t let them stay empty! 💧'**
  String get waterSortMessage;

  /// No description provided for @memoryGame.
  ///
  /// In en, this message translates to:
  /// **'Memory Game'**
  String get memoryGame;

  /// No description provided for @foodMemoryGame.
  ///
  /// In en, this message translates to:
  /// **'Food Memory Game'**
  String get foodMemoryGame;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @quizReminders.
  ///
  /// In en, this message translates to:
  /// **'Quiz Reminders'**
  String get quizReminders;

  /// No description provided for @quizRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications to remind users to play quiz'**
  String get quizRemindersDescription;

  /// No description provided for @periodicReminderScheduled.
  ///
  /// In en, this message translates to:
  /// **'Periodic reminder scheduled (every 2 days)'**
  String get periodicReminderScheduled;

  /// No description provided for @allRemindersScheduled.
  ///
  /// In en, this message translates to:
  /// **'All reminders scheduled'**
  String get allRemindersScheduled;

  /// No description provided for @allReminersCancelled.
  ///
  /// In en, this message translates to:
  /// **'All reminders cancelled'**
  String get allReminersCancelled;

  /// No description provided for @reminderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Reminder {taskName} cancelled'**
  String reminderCancelled(String taskName);

  /// No description provided for @timeToPlay.
  ///
  /// In en, this message translates to:
  /// **'🎮 Time to Play!'**
  String get timeToPlay;

  /// No description provided for @timeToPlayBody.
  ///
  /// In en, this message translates to:
  /// **'Hey! Ready for some fun quizzes? Let\'s keep learning! 🌟'**
  String get timeToPlayBody;

  /// No description provided for @backgroundTaskExecuted.
  ///
  /// In en, this message translates to:
  /// **'Background task executed: {taskName}'**
  String backgroundTaskExecuted(String taskName);

  /// No description provided for @notificationSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Notification sent successfully'**
  String get notificationSentSuccessfully;

  /// No description provided for @errorShowingNotification.
  ///
  /// In en, this message translates to:
  /// **'Error showing notification: {error}'**
  String errorShowingNotification(String error);

  /// No description provided for @iOSNotificationPermission.
  ///
  /// In en, this message translates to:
  /// **'iOS notification permission: {permission}'**
  String iOSNotificationPermission(String permission);

  /// No description provided for @notificationTapped.
  ///
  /// In en, this message translates to:
  /// **'Notification tapped: {payload}'**
  String notificationTapped(String payload);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failedToUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Failed to upgrade. Please try again.'**
  String get failedToUpgrade;

  /// No description provided for @unlockAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Features!'**
  String get unlockAllFeatures;

  /// No description provided for @joinThousandsOfPremiumUsers.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of premium users'**
  String get joinThousandsOfPremiumUsers;

  /// No description provided for @whatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What You Get:'**
  String get whatYouGet;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Payment • 100% Safe'**
  String get securePayment;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @enjoyUnlimitedAccess.
  ///
  /// In en, this message translates to:
  /// **'Enjoy unlimited access to all features!'**
  String get enjoyUnlimitedAccess;

  /// No description provided for @accessToMusicSportsCategories.
  ///
  /// In en, this message translates to:
  /// **'Access to Music & Sports categories'**
  String get accessToMusicSportsCategories;

  /// No description provided for @unlimitedQuizAttempts.
  ///
  /// In en, this message translates to:
  /// **'Unlimited quiz attempts'**
  String get unlimitedQuizAttempts;

  /// No description provided for @adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get adFreeExperience;

  /// No description provided for @priorityCustomerSupport.
  ///
  /// In en, this message translates to:
  /// **'Priority customer support'**
  String get priorityCustomerSupport;

  /// No description provided for @allFutureUpdatesIncluded.
  ///
  /// In en, this message translates to:
  /// **'All future updates included'**
  String get allFutureUpdatesIncluded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
