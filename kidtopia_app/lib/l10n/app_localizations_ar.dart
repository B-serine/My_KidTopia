// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get categories => 'الفئات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get guest => 'ضيف';

  @override
  String get readyToPlay => 'هل أنت مستعد للعب؟';

  @override
  String showUsPowers(String username) {
    return 'أرنا قدراتك $username!';
  }

  @override
  String get letsGo => 'هيا بنا';

  @override
  String get premiumRequired => 'يتطلب الاشتراك المميز';

  @override
  String get unlockCategory => 'افتح هذه الفئة مع الاشتراك المميز!';

  @override
  String get maybeLater => 'ربما لاحقاً';

  @override
  String get getPremium => 'احصل على المميز';

  @override
  String get scoreRequired => 'النقاط المطلوبة';

  @override
  String needPoints(int requiredScore, String categoryName) {
    return 'تحتاج إلى $requiredScore نقطة لفتح $categoryName!';
  }

  @override
  String earnMorePoints(int points) {
    return 'اكسب $points نقطة إضافية.';
  }

  @override
  String get ok => 'حسناً';

  @override
  String get keepPlaying => 'استمر في اللعب';

  @override
  String get loadingCategories => 'جاري تحميل الفئات...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noCategoriesYet => 'لا توجد فئات بعد';

  @override
  String get categoriesWillAppear =>
      'ستظهر الفئات هنا بمجرد إضافتها إلى قاعدة البيانات';

  @override
  String get refresh => 'تحديث';

  @override
  String ptsRequired(int points) {
    return '$points نقطة مطلوبة';
  }

  @override
  String get premium => 'مميز';

  @override
  String get becomePro => 'كن عضواً محترفاً';

  @override
  String get premiumMember => 'عضو مميز';

  @override
  String get freeMember => 'عضو مجاني';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get points => 'النقاط';

  @override
  String get bestGames => 'أفضل الألعاب';

  @override
  String get unlocked => 'مفتوح';

  @override
  String get myScore => 'نقاطي';

  @override
  String scorePoints(int score) {
    return '$score نقطة';
  }

  @override
  String get paymentSettings => 'إعدادات الدفع';

  @override
  String get paymentComingSoon => 'إعدادات الدفع قريباً!';

  @override
  String get nowPremium => 'أنت الآن عضو مميز!';

  @override
  String get loadingQuestions => 'جاري تحميل الأسئلة من قاعدة البيانات...';

  @override
  String get noQuestionsAvailable => 'لا توجد أسئلة متاحة';

  @override
  String get questionsNeeded =>
      'يجب إضافة أسئلة إلى قاعدة البيانات لهذه الفئة.';

  @override
  String get chooseAnotherCategory => 'اختر فئة أخرى';

  @override
  String get question => 'سؤال';

  @override
  String questionOf(int current, int total) {
    return 'السؤال $current من $total';
  }

  @override
  String addPoints(int points) {
    return '+$points نقطة';
  }

  @override
  String get noAnswersFound => 'لم يتم العثور على إجابات لهذا السؤال';

  @override
  String get checkAnswer => 'تحقق من الإجابة';

  @override
  String correctAnswer(int points) {
    return 'صحيح! +$points نقطة';
  }

  @override
  String get wrongAnswer => 'إجابة خاطئة!';

  @override
  String get chooseCategory => 'اختر فئة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get arabic => 'العربية';

  @override
  String get scoreScreenTitle => 'ممتاز!';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String get goodTry => 'محاولة جيدة!';

  @override
  String get keepPracticing => 'استمر في التدريب!';

  @override
  String get pointsEarned => 'نقطة';

  @override
  String get correct => 'صحيح';

  @override
  String get totalScore => 'النقاط الإجمالية';

  @override
  String nextGameIn(int seconds) {
    return 'اللعبة التالية في $seconds ثانية...';
  }

  @override
  String get scoreToUnlock => 'احرز 7+ لفتح لعبة صغيرة!';

  @override
  String get playAgain => 'العب مرة أخرى';

  @override
  String get nextNow => 'التالي الآن';

  @override
  String get noReward => 'لا مكافأة';

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get kidtopia => 'كيدتوبيا';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get letsPlayAgain => 'لنلعب مرة أخرى!';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get letsGetStarted => 'لنبدأ!';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get enterUsername => 'أدخل اسم المستخدم';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get createUsername => 'أنشئ اسم مستخدم';

  @override
  String get createPassword => 'أنشئ كلمة مرور';

  @override
  String get reenterPassword => 'أعد إدخال كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get passwordResetSoon => 'إعادة تعيين كلمة المرور قريباً!';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get pleaseEnterUsername => 'الرجاء إدخال اسم المستخدم';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get pleaseConfirmPassword => 'الرجاء تأكيد كلمة المرور';

  @override
  String get usernameMinLength => 'يجب أن يكون اسم المستخدم 3 أحرف على الأقل';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 4 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get timesUp => 'انتهى الوقت!';

  @override
  String get dontGiveUp => 'لا تستسلم!\nحاول مرة أخرى! 💪';

  @override
  String get goodJobVictory => 'عمل جيد!';

  @override
  String get youSolvedGame => 'لقد حللت اللعبة!';

  @override
  String get youWin => '🎉 لقد فزت! 🎉';

  @override
  String get amazingMemory => 'ذاكرة مذهلة!';

  @override
  String get playAgainButton => '🔄 العب مرة أخرى';

  @override
  String get homeButton => '🏠 الرئيسية';

  @override
  String get initializationError => 'خطأ في التهيئة';

  @override
  String get learningMadeFun => 'التعلم بطريقة ممتعة!';

  @override
  String get initializing => 'جاري التهيئة...';

  @override
  String get level => 'المستوى';

  @override
  String get levelComplete => 'اكتمل المستوى!';

  @override
  String get nextLevel => 'المستوى التالي';

  @override
  String get petCareGame => 'لعبة رعاية الحيوانات الأليفة';

  @override
  String get time => 'الوقت';

  @override
  String get happiness => 'السعادة';

  @override
  String get fullness => 'الشبع';

  @override
  String get play => 'العب';

  @override
  String get pet => 'المس';

  @override
  String get tryAgain => 'حاول مرة أخرى!';

  @override
  String get startGame => 'ابدأ اللعبة!';

  @override
  String get ohNo => 'يا للأسف!';

  @override
  String get petGameOverMessage =>
      'أصبح حيوانك الأليف حزينًا جدًا أو جائعًا!\nحاول إبقاء كلا الشريطين فوق 90٪!';

  @override
  String get feedYourPet => 'أطعم حيوانك الأليف';

  @override
  String get chooseYourPet => 'اختر حيوانك الأليف';

  @override
  String get howToWin => 'كيف تفوز:';

  @override
  String get petGameInstructions =>
      '🎯 الهدف: حافظ على سعادة حيوانك الأليف وإطعامه لمدة 60 ثانية!\n\n✅ الفوز: يبقى كلا الشريطين فوق 90٪\n❌ الخسارة: أي شريط يصل إلى 0٪\n\n💡 نصائح:\n• أطعم كثيرًا للحفاظ على الشبع\n• العب والمس للسعادة\n• اللعب يجعل الحيوان جائعًا!\n• الأطعمة المختلفة تعطي دفعات مختلفة';

  @override
  String get rainbowMonsterCollector => 'جامع الوحوش قوس قزح';

  @override
  String get customizeGame => 'خصص لعبتك!';

  @override
  String get chooseMonsterType => 'اختر نوع الوحش:';

  @override
  String get chooseBackground => 'اختر الخلفية:';

  @override
  String get howToPlay => 'كيف تلعب:';

  @override
  String monsterGameGoal(Object score) {
    return '🎯 الهدف: احصل على $score نقطة للفوز!';
  }

  @override
  String get monsterGameInstructions =>
      '👆 انقر على الوحوش القافزة للإمساك بها (10 نقاط لكل منها).\n⏰ لديك 60 ثانية. حظ سعيد! 🎈';

  @override
  String get waterSortGame => 'لعبة ترتيب الماء';

  @override
  String get waterSortMessage => 'لا تدعهم يبقون فارغين! 💧';

  @override
  String get memoryGame => 'لعبة الذاكرة';

  @override
  String get foodMemoryGame => 'لعبة الذاكرة';

  @override
  String get skip => 'تخطي';

  @override
  String get quizReminders => 'تذكيرات الاختبار';

  @override
  String get quizRemindersDescription => 'إشعارات لتذكير المستخدمين باللعب';

  @override
  String get periodicReminderScheduled => 'تم جدولة التذكير الدوري (كل يومين)';

  @override
  String get allRemindersScheduled => 'تم جدولة جميع التذكيرات';

  @override
  String get allReminersCancelled => 'تم إلغاء جميع التذكيرات';

  @override
  String reminderCancelled(String taskName) {
    return 'تم إلغاء التذكير $taskName';
  }

  @override
  String get timeToPlay => '🎮 حان وقت اللعب!';

  @override
  String get timeToPlayBody =>
      'مرحباً! هل أنت مستعد لاختبارات ممتعة؟ لنستمر في التعلم! 🌟';

  @override
  String backgroundTaskExecuted(String taskName) {
    return 'تم تنفيذ المهمة الخلفية: $taskName';
  }

  @override
  String get notificationSentSuccessfully => 'تم إرسال الإشعار بنجاح';

  @override
  String errorShowingNotification(String error) {
    return 'خطأ في عرض الإشعار: $error';
  }

  @override
  String iOSNotificationPermission(String permission) {
    return 'إذن الإشعار على iOS: $permission';
  }

  @override
  String notificationTapped(String payload) {
    return 'تم النقر على الإشعار: $payload';
  }

  @override
  String get error => 'خطأ';

  @override
  String get failedToUpgrade => 'فشل الترقية. يرجى المحاولة مرة أخرى.';

  @override
  String get unlockAllFeatures => 'فتح جميع الميزات!';

  @override
  String get joinThousandsOfPremiumUsers => 'انضم إلى آلاف مستخدمي البريميوم';

  @override
  String get whatYouGet => 'ما الذي تحصل عليه:';

  @override
  String get processing => 'جاري المعالجة...';

  @override
  String get securePayment => 'دفع آمن • آمن 100%';

  @override
  String get congratulations => 'تهانينا!';

  @override
  String get enjoyUnlimitedAccess =>
      'استمتع بالوصول غير المحدود إلى جميع الميزات!';

  @override
  String get accessToMusicSportsCategories =>
      'الوصول إلى فئات الموسيقى والرياضة';

  @override
  String get unlimitedQuizAttempts => 'محاولات اختبار غير محدودة';

  @override
  String get adFreeExperience => 'تجربة خالية من الإعلانات';

  @override
  String get priorityCustomerSupport => 'دعم العملاء ذو الأولوية';

  @override
  String get allFutureUpdatesIncluded => 'جميع التحديثات المستقبلية مضمنة';
}
