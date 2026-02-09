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
  static const String DIALOG_DELETE_POST_TITLE = 'dialog.deletePost.title';
  static const String DIALOG_DELETE_POST_MESSAGE = 'dialog.deletePost.message';
  // AUTHENTICATION
  static const String LOGIN = 'authentication.login';
  static const String EMAIL = 'authentication.email';
  static const String PASSWORD = 'authentication.password';
  static const String CONFIRM_PASSWORD = 'authentication.confirmPassword';
  static const String FORGOT_PASSWORD = 'authentication.forgotPassword';
  static const String HAVE_ACCOUNT = 'authentication.haveAccount';
  static const String CHECK = 'authentication.checkButton';
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
  static const String CHOOSE_USERNAME_MIN_LENGTH =
      'authentication.pageChooseUsername.minLength';
  static const String CHOOSE_USERNAME_CASE_INSENSITIVE =
      'authentication.pageChooseUsername.caseInsensitive';
  static const String CHOOSE_USERNAME_IS_AVAILABLE =
      'authentication.pageChooseUsername.isAvailable';
  static const String CHOOSE_USERNAME_IS_NOT_AVAILABLE =
      'authentication.pageChooseUsername.isNotAvailable';
  static const String CHOOSE_USERNAME_SUGGESTIONS =
      'authentication.pageChooseUsername.suggestions';
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
  static const String ERROR_WELCOME_PAGE = 'authentication.errors.welcomePage';
  static const String ERROR_LOGIN_PAGE = 'authentication.errors.loginPage';
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
  static const String ANALYTICS_LAST_30_DAYS = 'analytics.last30Days';
  static const String ANALYTICS_LAST_6_MONTHS = 'analytics.last6Months';
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

  // INBOX
  static const String INBOX_TITLE = 'inbox.title';
  static const String INBOX_MESSAGES = 'inbox.messages';
  static const String INBOX_NOTIFICATIONS = 'inbox.notifications';
  static const String INBOX_SENT_A_PHOTO = 'inbox.sentAPhoto';
  static const String INBOX_TODAYS_ACTIVITY = 'inbox.todaysActivity';
  static const String INBOX_KEEP_POSTING = 'inbox.keepPosting';

  // CHAT
  static const String CHAT_TYPE_MESSAGE = 'chat.typeMessage';
  static const String CHAT_NO_MESSAGES = 'chat.noMessages';
  static const String CHAT_YESTERDAY = 'chat.yesterday';

  // ERROR STATES
  static const String ERROR_OCCURRED = 'error.occurred';
  static const String ERROR_TRY_AGAIN = 'error.tryAgain';
  static const String ERROR_NO_POSTS = 'error.noPosts';
  static const String ERROR_REFRESH = 'error.refresh';

  // COMMENTS
  static const String COMMENTS_TITLE = 'comments.title';
  static const String COMMENTS_REPLY = 'comments.reply';
  static const String COMMENTS_ADD_PLACEHOLDER = 'comments.addPlaceholder';
  static const String COMMENTS_VIEW_REPLIES = 'comments.viewReplies';
  static const String COMMENTS_LIKES = 'comments.likes';

  // POST ACTIONS
  static const String POST_LIKED = 'post.liked';
  static const String POST_DISLIKED = 'post.disliked';

  // DAYS
  static const String DAY_MONDAY = 'days.monday';
  static const String DAY_TUESDAY = 'days.tuesday';
  static const String DAY_WEDNESDAY = 'days.wednesday';
  static const String DAY_THURSDAY = 'days.thursday';
  static const String DAY_FRIDAY = 'days.friday';
  static const String DAY_SATURDAY = 'days.saturday';
  static const String DAY_SUNDAY = 'days.sunday';

  // MONTHS
  static const String MONTH_JANUARY = 'months.january';
  static const String MONTH_FEBRUARY = 'months.february';
  static const String MONTH_MARCH = 'months.march';
  static const String MONTH_APRIL = 'months.april';
  static const String MONTH_MAY = 'months.may';
  static const String MONTH_JUNE = 'months.june';
  static const String MONTH_JULY = 'months.july';
  static const String MONTH_AUGUST = 'months.august';
  static const String MONTH_SEPTEMBER = 'months.september';
  static const String MONTH_OCTOBER = 'months.october';
  static const String MONTH_NOVEMBER = 'months.november';
  static const String MONTH_DECEMBER = 'months.december';

  // FEED ERRORS (Backend)
  static const String FEED_ERROR_LOADING_POSTS = 'feed.error.loadingPosts';
  static const String FEED_ERROR_LOADING_MORE = 'feed.error.loadingMore';

  // FIREBASE ERRORS (Backend)
  static const String FIREBASE_ERROR_CREATE_DOCUMENT =
      'firebase.error.createDocument';
  static const String FIREBASE_ERROR_READ_DOCUMENT =
      'firebase.error.readDocument';
  static const String FIREBASE_ERROR_READ_DOCUMENTS =
      'firebase.error.readDocuments';
  static const String FIREBASE_ERROR_QUERY = 'firebase.error.query';
  static const String FIREBASE_ERROR_UPDATE_DOCUMENT =
      'firebase.error.updateDocument';
  static const String FIREBASE_ERROR_SET_DOCUMENT =
      'firebase.error.setDocument';
  static const String FIREBASE_ERROR_DELETE_DOCUMENT =
      'firebase.error.deleteDocument';
  static const String FIREBASE_ERROR_CHECK_USER = 'firebase.error.checkUser';

  // GENERAL
  static const String GENERAL_PAGE_NOT_FOUND = 'general.pageNotFound';
  static const String GENERAL_USER_NOT_FOUND = 'general.userNotFound';

  // PROFILE
  static const String PROFILE_FOLLOWER = 'profile.follower';
  static const String PROFILE_FOLLOWING = 'profile.following';
  static const String PROFILE_FOLLOW = 'profile.follow';
  static const String PROFILE_EDIT = 'profile.edit';
  static const String PROFILE_MESSAGE = 'profile.message';
  static const String PROFILE_PHOTOS = 'profile.photos';
  static const String PROFILE_SAVES = 'profile.saves';
  static const String PROFILE_DRAFTS = 'profile.drafts';
  static const String PROFILE_READ_MORE = 'profile.readMore';
  static const String PROFILE_HIDE = 'profile.hide';
  static const String PROFILE_EMPTY_BIO = 'profile.emptyBio';
  static const String NON_POST = 'profile.nonPost';

  // FOLLOW LIST
  static const String FOLLOW_LIST_SEARCH = 'followList.search';
  static const String FOLLOW_LIST_EMPTY = 'followList.empty';

  // STYLE TAGS
  static String STYLE_TAG(String tag) => "styleTags.$tag";
  static const String OVERSIZED = 'styleTags.oversized';
  static const String STREETWEAR = 'styleTags.streetwear';
  static const String MODELLING = 'styleTags.modelling';
  static const String CASUAL = 'styleTags.casual';
  static const String FORMAL = 'styleTags.formal';
  static const String VINTAGE = 'styleTags.vintage';
  static const String SPORTY = 'styleTags.sporty';
  static const String BOHEMIAN = 'styleTags.bohemian';
  static const String Y2K = 'styleTags.y2k';
  static const String GOTH = 'styleTags.goth';
  static const String MINIMALIST = 'styleTags.minimalist';
  static const String TECHWEAR = 'styleTags.techwear';
  static const String SKATER = 'styleTags.skater';
  static const String RETRO = 'styleTags.retro';
  static const String CLEAN = 'styleTags.clean';
  static const String GIRL = 'styleTags.girl';
  // POST DETAIL
  static const String POST_DETAIL_COMMENTS = 'postDetail.comments';
  static const String POST_DETAIL_BOOKMARKED = 'postDetail.bookmarked';
  static const String POST_DETAIL_SHARES = 'postDetail.shares';

  // PROFILE EDIT
  static const String PROFILE_EDIT_APPBAR = 'profileEdit.appbar';
  static const String PROFILE_EDIT_DONE = 'profileEdit.done';
  static const String PROFILE_EDIT_CHANGE_PHOTO = 'profileEdit.changePhoto';
  static const String PROFILE_EDIT_NAME = 'profileEdit.name';
  static const String PROFILE_EDIT_USERNAME = 'profileEdit.username';
  static const String PROFILE_EDIT_BIO = 'profileEdit.bio';
  static const String PROFILE_EDIT_MY_STYLES = 'profileEdit.myStyles';
  static const String PROFILE_EDIT_ADD_NEW = 'profileEdit.addNew';
  static const String PROFILE_EDIT_SELECT_PHOTO = 'profileEdit.selectPhoto';
  static const String PROFILE_EDIT_TAKE_PHOTO = 'profileEdit.takePhoto';
  static const String PROFILE_EDIT_CHOOSE_FROM_GALLERY =
      'profileEdit.chooseFromGallery';
  static const String PROFILE_EDIT_SELECT_MEDIA_TYPE =
      'profileEdit.selectMediaType';
  static const String PROFILE_EDIT_PHOTO = 'profileEdit.photo';
  static const String PROFILE_EDIT_VIDEO = 'profileEdit.video';
  static const String PROFILE_EDIT_SELECT_SOURCE = 'profileEdit.selectSource';
  static const String PROFILE_EDIT_CAMERA = 'profileEdit.camera';
  static const String PROFILE_EDIT_GALLERY = 'profileEdit.gallery';
  static const String PROFILE_EDIT_STORY_CREATED_SUCCESS =
      'profileEdit.storyCreatedSuccess';
  static const String PROFILE_EDIT_STORY_CREATED_ERROR =
      'profileEdit.storyCreatedError';

  // SETTINGS
  static const String SETTINGS_TITLE = 'settings.title';
  static const String SETTINGS_ACCOUNT = 'settings.account';
  static const String SETTINGS_USERNAME = 'settings.username';
  static const String SETTINGS_EMAIL = 'settings.email';
  static const String SETTINGS_CHANGE_PASSWORD = 'settings.changePassword';
  static const String SETTINGS_SUPPORT = 'settings.support';
  static const String SETTINGS_CONTACT_SUPPORT = 'settings.contactSupport';
  static const String SETTINGS_NOTIFICATIONS = 'settings.notifications';
  static const String SETTINGS_LIKES = 'settings.likes';
  static const String SETTINGS_SAVES = 'settings.saves';
  static const String SETTINGS_MILESTONES = 'settings.milestones';
  static const String SETTINGS_TRENDING = 'settings.trending';
  static const String SETTINGS_FOLLOW = 'settings.follow';
  static const String SETTINGS_APP = 'settings.app';
  static const String SETTINGS_DARK_MODE = 'settings.darkMode';
  static const String SETTINGS_THEME_MODE = 'settings.themeMode';
  static const String SETTINGS_THEME_MODE_AUTO = 'settings.themeModeAuto';
  static const String SETTINGS_THEME_MODE_LIGHT = 'settings.themeModeLight';
  static const String SETTINGS_THEME_MODE_DARK = 'settings.themeModeDark';
  static const String SETTINGS_LANGUAGE = 'settings.language';
  static const String SETTINGS_LANGUAGE_VALUE = 'settings.languageValue';
  static const String SETTINGS_ABOUT = 'settings.about';
  static const String SETTINGS_TERMS_OF_SERVICE = 'settings.termsOfService';
  static const String SETTINGS_PRIVACY_POLICY = 'settings.privacyPolicy';
  static const String SETTINGS_LOG_OUT = 'settings.logOut';
  static const String SETTINGS_DEACTIVE_ACCOUNT = 'settings.deactiveAccount';
  static const String SETTINGS_VERSION = 'settings.version';

  static const String SETTINGS_SUPPORT_EMAIL_SUBJECT =
      "settings.supportEmailSubject";
  static const String SETTINGS_SHARE_US = "settings.shareUs";
  static const String SETTINGS_SHARE_TEXT = "settings.shareText";
  static const String SETTINGS_RATE_US = "settings.rateUs";

  // INBOX
  static const String INBOX_SYSTEM_NOTIFICATIONS_TITLE =
      'inbox.systemNotifications.title';
  static const String INBOX_SYSTEM_NOTIFICATIONS_ACCOUNT_UPDATES =
      'inbox.systemNotifications.accountUpdates';
  static const String INBOX_NEW_FOLLOWERS_TITLE = 'inbox.newFollowers.title';
  static const String INBOX_NEW_FOLLOWERS_SUGGESTED_ACCOUNTS =
      'inbox.newFollowers.suggestedAccounts';
  static const String INBOX_NEW_FOLLOWERS_HIDE = 'inbox.newFollowers.hide';
  static const String INBOX_NEW_FOLLOWERS_VIEW_MORE =
      'inbox.newFollowers.viewMore';
  static const String INBOX_FOLLOW_BACK = 'inbox.followBack';
  static const String INBOX_REMOVE = 'inbox.remove';
  static const String INBOX_FOLLOW = 'inbox.follow';
  static const String INBOX_STARTED_FOLLOWING_YOU =
      'inbox.newFollowers.startedFollowingYou';

  // TIME
  static const String TIME_MINUTES_AGO = 'time.minutesAgo';
  static const String TIME_HOURS_AGO = 'time.hoursAgo';
  static const String TIME_DAYS_AGO = 'time.daysAgo';
  static const String TIME_WEEKS_AGO = 'time.weeksAgo';
  static const String TIME_MONTHS_AGO = 'time.monthsAgo';
  static const String TIME_YEARS_AGO = 'time.yearsAgo';

  // FEED NEW
  static const String FEED_TREND = 'feed.trend';

  // LOCATION
  static const String LOCATION_NO_RESULTS = 'location.noResults';

  // AUTH EXTENSION
  static const String AUTHENTICATION_REGISTER_ERROR =
      'authentication.registerError';

  // NOTIFICATION SETTINGS
  static const String NOTIFICATION_SETTINGS_TITLE =
      'notificationSettings.title';
  static const String NOTIFICATION_SETTINGS_DESCRIPTION =
      'notificationSettings.description';
  static const String NOTIFICATION_SETTINGS_OPTION_ALL =
      'notificationSettings.optionAll';
  static const String NOTIFICATION_SETTINGS_OPTION_NONE =
      'notificationSettings.optionNone';
}
