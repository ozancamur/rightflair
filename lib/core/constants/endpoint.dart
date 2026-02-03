enum Endpoint {
  CREATE_USER("create-user"),
  CHECK_USERNAME("check-username"),
  UPDATE_USER("update-user"),

  GET_USER("get-user"),
  GET_USER_POSTS("get-user-posts"),
  GET_USER_SAVED_POSTS("get-user-saved-posts"),
  GET_USER_DRAFTS("get-user-drafts"),

  GET_USER_STYLE_TAGS("get-user-style-tags"),
  UPDATE_USER_STYLE_TAGS("update-user-style-tags"),

  GET_USER_SETTINGS("get-user-settings"),
  UPDATE_USER_SETTINGS("update-user-settings"),
  DELETE_USER("delete-user"),

  GET_DISCOVER_FEED("get-discover-feed"),
  GET_FOLLOWING_FEED("get-following-feed"),
  GET_FRIENDS_FEED("get-friends-feed"),

  POST_LIKE("post-like"),
  POST_DISLIKE("post-dislike"),

  GET_POST_COMMENTS("get-post-comments"),
  CREATE_COMMENT("create-comment"),
  SAVE_POST("save-post"),
  DELETE_POST("delete-post"),

  GET_CONVERSATIONS("get-conversations"),
  GET_CONVERSATION_MESSAGES("get-conversation-messages"),
  SEND_MESSAGE_TO_CONVERSATION("send-message-to-conversation"),
  
  GET_ANALYSIS("get-analysis")
  ;
  

  final String value;
  const Endpoint(this.value);
}
