// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get home => 'Accueil';

  @override
  String get categories => 'Catégories';

  @override
  String get profile => 'Profil';

  @override
  String get guest => 'Invité';

  @override
  String get readyToPlay => 'Prêt à Jouer?';

  @override
  String showUsPowers(String username) {
    return 'Montrez-nous vos pouvoirs $username!';
  }

  @override
  String get letsGo => 'Allons-y';

  @override
  String get premiumRequired => 'Premium Requis';

  @override
  String get unlockCategory =>
      'Débloquez cette catégorie avec l\'abonnement Premium!';

  @override
  String get maybeLater => 'Peut-être Plus Tard';

  @override
  String get getPremium => 'Obtenir Premium';

  @override
  String get scoreRequired => 'Score Requis';

  @override
  String needPoints(int requiredScore, String categoryName) {
    return 'Vous avez besoin de $requiredScore points pour débloquer $categoryName!';
  }

  @override
  String earnMorePoints(int points) {
    return 'Gagnez $points points supplémentaires.';
  }

  @override
  String get ok => 'OK';

  @override
  String get keepPlaying => 'Continuer à Jouer';

  @override
  String get loadingCategories => 'Chargement des catégories...';

  @override
  String get retry => 'Réessayer';

  @override
  String get noCategoriesYet => 'Pas Encore de Catégories';

  @override
  String get categoriesWillAppear =>
      'Les catégories apparaîtront ici une fois ajoutées à la base de données';

  @override
  String get refresh => 'Actualiser';

  @override
  String ptsRequired(int points) {
    return '$points pts requis';
  }

  @override
  String get premium => 'Premium';

  @override
  String get becomePro => 'Devenir membre pro';

  @override
  String get premiumMember => 'Membre Premium';

  @override
  String get freeMember => 'Membre Gratuit';

  @override
  String get logout => 'Déconnexion';

  @override
  String get points => 'Points';

  @override
  String get bestGames => 'Meilleurs jeux';

  @override
  String get unlocked => 'Débloqué';

  @override
  String get myScore => 'Mon score';

  @override
  String scorePoints(int score) {
    return '$score points';
  }

  @override
  String get paymentSettings => 'Paramètres de paiement';

  @override
  String get paymentComingSoon => 'Paramètres de paiement bientôt disponibles!';

  @override
  String get nowPremium => 'Vous êtes maintenant membre premium!';

  @override
  String get loadingQuestions =>
      'Chargement des questions depuis la base de données...';

  @override
  String get noQuestionsAvailable => 'Aucune Question Disponible';

  @override
  String get questionsNeeded =>
      'Des questions doivent être ajoutées à la base de données pour cette catégorie.';

  @override
  String get chooseAnotherCategory => 'Choisir une Autre Catégorie';

  @override
  String get question => 'Question';

  @override
  String questionOf(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String addPoints(int points) {
    return '+$points points';
  }

  @override
  String get noAnswersFound => 'Aucune réponse trouvée pour cette question';

  @override
  String get checkAnswer => 'Vérifier la Réponse';

  @override
  String correctAnswer(int points) {
    return 'Correct! +$points points';
  }

  @override
  String get wrongAnswer => 'Mauvaise réponse!';

  @override
  String get chooseCategory => 'Choisir une Catégorie';

  @override
  String get changeLanguage => 'Changer la Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'Arabe';

  @override
  String get scoreScreenTitle => 'Excellent!';

  @override
  String get greatJob => 'Bon Travail!';

  @override
  String get goodTry => 'Bonne Tentative!';

  @override
  String get keepPracticing => 'Continuez à Vous Entraîner!';

  @override
  String get pointsEarned => 'points';

  @override
  String get correct => 'Correct';

  @override
  String get totalScore => 'Score Total';

  @override
  String nextGameIn(int seconds) {
    return 'Prochain jeu dans $seconds secondes...';
  }

  @override
  String get scoreToUnlock => 'Marquez 7+ pour débloquer un mini-jeu!';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get nextNow => 'Suivant';

  @override
  String get noReward => 'Pas de Récompense';

  @override
  String get goHome => 'Accueil';

  @override
  String get signIn => 'Se Connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get kidtopia => 'Kidtopia';

  @override
  String get welcomeBack => 'Bon Retour!';

  @override
  String get letsPlayAgain => 'Jouons encore!';

  @override
  String get createAccount => 'Créer un Compte';

  @override
  String get letsGetStarted => 'Commençons!';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le Mot de Passe';

  @override
  String get enterUsername => 'Entrez votre nom d\'utilisateur';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get createUsername => 'Créez un nom d\'utilisateur';

  @override
  String get createPassword => 'Créez un mot de passe';

  @override
  String get reenterPassword => 'Ressaisissez votre mot de passe';

  @override
  String get forgotPassword => 'Mot de Passe Oublié?';

  @override
  String get passwordResetSoon =>
      'Réinitialisation du mot de passe bientôt disponible!';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get pleaseEnterUsername => 'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get pleaseConfirmPassword => 'Veuillez confirmer votre mot de passe';

  @override
  String get usernameMinLength =>
      'Le nom d\'utilisateur doit contenir au moins 3 caractères';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 4 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get timesUp => 'Temps Écoulé!';

  @override
  String get dontGiveUp => 'N\'abandonnez pas!\nRéessayez! 💪';

  @override
  String get goodJobVictory => 'Bon Travail!';

  @override
  String get youSolvedGame => 'Vous avez résolu le jeu!';

  @override
  String get youWin => '🎉 VOUS GAGNEZ! 🎉';

  @override
  String get amazingMemory => 'Mémoire Incroyable!';

  @override
  String get playAgainButton => '🔄 Rejouer';

  @override
  String get homeButton => '🏠 Accueil';

  @override
  String get initializationError => 'Erreur d\'Initialisation';

  @override
  String get learningMadeFun => 'L\'apprentissage rendu amusant!';

  @override
  String get initializing => 'Initialisation...';

  @override
  String get level => 'Niveau';

  @override
  String get levelComplete => 'Niveau Terminé!';

  @override
  String get nextLevel => 'Niveau Suivant';

  @override
  String get petCareGame => 'Jeu de Soin des Animaux';

  @override
  String get time => 'Temps';

  @override
  String get happiness => 'Bonheur';

  @override
  String get fullness => 'Satiété';

  @override
  String get play => 'Jouer';

  @override
  String get pet => 'Caresser';

  @override
  String get tryAgain => 'Réessayer!';

  @override
  String get startGame => 'Commencer le Jeu!';

  @override
  String get ohNo => 'Oh Non!';

  @override
  String get petGameOverMessage =>
      'Votre animal est devenu trop triste ou affamé!\nEssayez de garder les deux barres au-dessus de 90%!';

  @override
  String get feedYourPet => 'Nourrissez Votre Animal';

  @override
  String get chooseYourPet => 'Choisissez Votre Animal';

  @override
  String get howToWin => 'Comment Gagner:';

  @override
  String get petGameInstructions =>
      '🎯 Objectif: Gardez votre animal heureux et nourri pendant 60 secondes!\n\n✅ Victoire: Les deux barres restent au-dessus de 90%\n❌ Défaite: Une barre atteint 0%\n\n💡 Conseils:\n• Nourrissez souvent pour maintenir la satiété\n• Jouez et caressez pour le bonheur\n• Jouer rend l\'animal affamé!\n• Différents aliments donnent différents bonus';

  @override
  String get rainbowMonsterCollector => 'Collecteur de Monstres Arc-en-ciel';

  @override
  String get customizeGame => 'Personnalisez Votre Jeu!';

  @override
  String get chooseMonsterType => 'Choisir le Type de Monstre:';

  @override
  String get chooseBackground => 'Choisir l\'Arrière-plan:';

  @override
  String get howToPlay => 'Comment Jouer:';

  @override
  String monsterGameGoal(Object score) {
    return '🎯 Objectif: Marquez $score points pour gagner!';
  }

  @override
  String get monsterGameInstructions =>
      '👆 Tapez sur les monstres qui rebondissent pour les attraper (10 points chacun).\n⏰ Vous avez 60 secondes. Bonne chance! 🎈';

  @override
  String get waterSortGame => 'Jeu de Tri d\'Eau';

  @override
  String get waterSortMessage => 'Ne les laissez pas vides! 💧';

  @override
  String get memoryGame => 'Jeu de Mémoire';

  @override
  String get foodMemoryGame => 'Jeu de Mémoire';

  @override
  String get skip => 'Passer';

  @override
  String get quizReminders => 'Rappels de Quiz';

  @override
  String get quizRemindersDescription =>
      'Notifications pour rappeler aux utilisateurs de jouer au quiz';

  @override
  String get periodicReminderScheduled =>
      'Rappel périodique programmé (tous les 2 jours)';

  @override
  String get allRemindersScheduled => 'Tous les rappels sont programmés';

  @override
  String get allReminersCancelled => 'Tous les rappels annulés';

  @override
  String reminderCancelled(String taskName) {
    return 'Rappel $taskName annulé';
  }

  @override
  String get timeToPlay => '🎮 C\'est l\'heure de jouer!';

  @override
  String get timeToPlayBody =>
      'Hé! Prêt pour des quiz amusants? Continuons à apprendre! 🌟';

  @override
  String backgroundTaskExecuted(String taskName) {
    return 'Tâche de fond exécutée: $taskName';
  }

  @override
  String get notificationSentSuccessfully => 'Notification envoyée avec succès';

  @override
  String errorShowingNotification(String error) {
    return 'Erreur lors de l\'affichage de la notification: $error';
  }

  @override
  String iOSNotificationPermission(String permission) {
    return 'Permission de notification iOS: $permission';
  }

  @override
  String notificationTapped(String payload) {
    return 'Notification appuyée: $payload';
  }

  @override
  String get error => 'Erreur';

  @override
  String get failedToUpgrade =>
      'Impossible de mettre à niveau. Veuillez réessayer.';

  @override
  String get unlockAllFeatures => 'Déverrouiller toutes les fonctionnalités!';

  @override
  String get joinThousandsOfPremiumUsers =>
      'Rejoignez des milliers d\'utilisateurs premium';

  @override
  String get whatYouGet => 'Ce que vous obtenez:';

  @override
  String get processing => 'Traitement en cours...';

  @override
  String get securePayment => 'Paiement sécurisé • 100% sûr';

  @override
  String get congratulations => 'Félicitations!';

  @override
  String get enjoyUnlimitedAccess =>
      'Profitez d\'un accès illimité à toutes les fonctionnalités!';

  @override
  String get accessToMusicSportsCategories =>
      'Accès aux catégories Musique et Sports';

  @override
  String get unlimitedQuizAttempts => 'Tentatives de quiz illimitées';

  @override
  String get adFreeExperience => 'Expérience sans publicité';

  @override
  String get priorityCustomerSupport => 'Support client prioritaire';

  @override
  String get allFutureUpdatesIncluded => 'Tous les futurs mises à jour inclus';
}
