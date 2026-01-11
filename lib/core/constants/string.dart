class AppStrings {
  AppStrings._();

  // VALIDATION
  static const String VALIDATION_EMAIL_REQUIRED = 'validation.emailRequired';
  static const String VALIDATION_EMAIL_INVALID = 'validation.emailInvalid';
  static const String VALIDATION_PASSWORD_REQUIRED =
      'validation.passwordRequired';
  static const String VALIDATION_PASSWORD_INVALID =
      'validation.passwordInvalid';
  static const String VALIDATION_CONFIRM_PASSWORD_REQUIRED =
      'validation.confirmPasswordRequired';
  static const String VALIDATION_CONFIRM_PASSWORD_MISMATCH =
      'validation.confirmPasswordMismatch';

  // DIALOG
  static const String DIALOG_OK = 'dialog.ok';
  static const String DIALOG_CANCEL = 'dialog.cancel';
  static const String DIALOG_CONFIRM = 'dialog.confirm';
  // AUTHENTICATION
  static const String LOGIN = 'authentication.login';
  static const String EMAIL = 'authentication.email';
  static const String PASSWORD = 'authentication.password';
  static const String CONFIRM_PASSWORD = 'authentication.confirmPassword';
  static const String FORGOT_PASSWORD = 'authentication.forgotPassword';
  static const String HAVE_ACCOUNT = 'authentication.haveAccount';
  static const String CONTINUE = 'authentication.continueButton';
  // AUTHENTICATION - WELCOME
  static const String WELCOME_TITLE = 'authentication.pageWelcome.title';
  static const String WITH_MAIL = 'authentication.pageWelcome.withMail';
  static const String OR = 'authentication.pageWelcome.or';
  static const String WITH_GOOGLE = 'authentication.pageWelcome.withGoogle';
  static const String WITH_APPLE = 'authentication.pageWelcome.withApple';
  // AUTHENTICATION - REGISTER
  static const String REGISTER_APPBAR = 'authentication.pageRegister.appbar';
  static const String REGISTER_TITLE = 'authentication.pageRegister.title';
  static const String REGISTER_SUBTITLE =
      'authentication.pageRegister.subtitle';
  static const String REGISTER_CREATE_ACCOUNT =
      'authentication.pageRegister.createAccount';
  // AUTHENTICATION - CHOOSE_USERNAME
  static const String CHOOSE_USERNAME_APPBAR =
      'authentication.pageChooseUsername.appbar';
  static const String CHOOSE_USERNAME_TITLE =
      'authentication.pageChooseUsername.title';
  static const String CHOOSE_USERNAME_SUBTITLE =
      'authentication.pageChooseUsername.subtitle';
  static const String CHOOSE_USERNAME_USERNAME =
      'authentication.pageChooseUsername.username';
  static const String CHOOSE_USERNAME_UNIQUE =
      'authentication.pageChooseUsername.unique';
  static const String CHOOSE_USERNAME_CASE_INSENSITIVE =
      'authentication.pageChooseUsername.caseInsensitive';
  static const String CHOOSE_USERNAME_IS_AVAILABLE =
      'authentication.pageChooseUsername.isAvailable';
  static const String CHOOSE_USERNAME_IS_NOT_AVAILABLE =
      'authentication.pageChooseUsername.isNotAvailable';
  // AUTHENTICATION - LOGIN
  static const String LOGIN_TITLE = 'authentication.pageLogin.title';
  static const String LOGIN_SUBTITLE = 'authentication.pageLogin.subtitle';
  // AUTHENTICATION - FORGOT_PASSWORD
  static const String FORGOT_PASSWORD_APPBAR =
      'authentication.pageForgotPassword.appbar';
  static const String FORGOT_PASSWORD_TITLE =
      'authentication.pageForgotPassword.title';
  static const String FORGOT_PASSWORD_SUBTITLE =
      'authentication.pageForgotPassword.subtitle';
  static const String FORGOT_PASSWORD_SEND_RESET_EMAIL =
      'authentication.pageForgotPassword.sendResetEmail';
  // AUTHENTICATION - ERRORS
  static const String ERROR_WEAK_PASSWORD =
      'authentication.errors.weakPassword';
  static const String ERROR_EMAIL_ALREADY_IN_USE =
      'authentication.errors.emailAlreadyInUse';
  static const String ERROR_INVALID_EMAIL =
      'authentication.errors.invalidEmail';
  static const String ERROR_USER_NOT_FOUND =
      'authentication.errors.userNotFound';
  static const String ERROR_WRONG_PASSWORD =
      'authentication.errors.wrongPassword';
  static const String ERROR_USER_DISABLED =
      'authentication.errors.userDisabled';
  static const String ERROR_TOO_MANY_REQUESTS =
      'authentication.errors.tooManyRequests';
  static const String ERROR_OPERATION_NOT_ALLOWED =
      'authentication.errors.operationNotAllowed';
  static const String ERROR_REQUIRES_RECENT_LOGIN =
      'authentication.errors.requiresRecentLogin';
  static const String ERROR_INVALID_CREDENTIAL =
      'authentication.errors.invalidCredential';
  static const String ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL =
      'authentication.errors.accountExistsWithDifferentCredential';
  static const String ERROR_DEFAULT = 'authentication.errors.default';
  static const String ERROR_GENERIC_SIGNUP =
      'authentication.errors.genericSignup';
  static const String ERROR_GENERIC_SIGNIN =
      'authentication.errors.genericSignin';
  static const String ERROR_GENERIC_GOOGLE =
      'authentication.errors.genericGoogle';
  static const String ERROR_GENERIC_APPLE =
      'authentication.errors.genericApple';
  static const String ERROR_GENERIC_PASSWORD_RESET =
      'authentication.errors.genericPasswordReset';
  static const String ERROR_GENERIC_SIGNOUT =
      'authentication.errors.genericSignout';
  static const String ERROR_GENERIC_DELETE_ACCOUNT =
      'authentication.errors.genericDeleteAccount';
  static const String ERROR_GENERIC_EMAIL_VERIFICATION =
      'authentication.errors.genericEmailVerification';
  static const String ERROR_GENERIC_UPDATE_PROFILE =
      'authentication.errors.genericUpdateProfile';
  static const String ERROR_GENERIC_UPDATE_PASSWORD =
      'authentication.errors.genericUpdatePassword';

  // NAVIGATION
  static const String NAVIGATION_HOME = 'navigation.home';
  static const String NAVIGATION_ANALYTICS = 'navigation.analytics';
  static const String NAVIGATION_INBOX = 'navigation.inbox';
  static const String NAVIGATION_PROFILE = 'navigation.profile';
  // ANALYTICS
  static const String ANALYTICS_TITLE = 'analytics.title';
  static const String ANALYTICS_SHARE = 'analytics.share';
  static const String ANALYTICS_LIKES = 'analytics.likes';
  static const String ANALYTICS_FOLLOWERS = 'analytics.followers';
  static const String ANALYTICS_SAVES = 'analytics.saves';
  static const String ANALYTICS_ENGAGEMENT_OVERVIEW =
      'analytics.engagementOverview';
  static const String ANALYTICS_LAST_7_DAYS = 'analytics.last7Days';
  // FEED
  static const String FEED_DISCOVER = 'feed.discover';
  static const String FEED_FOLLOWING = 'feed.following';
  static const String FEED_FRIENDS = 'feed.friends';

  // SEARCH
  static const String SEARCH_PLACEHOLDER = 'search.placeholder';
  static const String SEARCH_RECENT_SEARCHES = 'search.recentSearches';

  // CREATE POST
  static const String CREATE_POST_APPBAR = 'createPost.appbar';
  static const String CREATE_POST_ABOUT_OUTFIT = 'createPost.aboutOutfit';
  static const String CREATE_POST_DESCRIPTION_PLACEHOLDER =
      'createPost.descriptionPlaceholder';
  static const String CREATE_POST_LOCATION = 'createPost.location';
  static const String CREATE_POST_ANONYMOUSLY = 'createPost.postAnonymously';
  static const String CREATE_POST_ANONYMOUSLY_SUBTITLE =
      'createPost.postAnonymouslySubtitle';
  static const String CREATE_POST_ALLOW_COMMENTS = 'createPost.allowComments';
  static const String CREATE_POST_DRAFT = 'createPost.draft';
  static const String CREATE_POST_POST = 'createPost.post';
  static const String CREATE_POST_SELECT_LOCATION = 'createPost.selectLocation';
  static const String CREATE_POST_SEARCH_LOCATION = 'createPost.searchLocation';
}
