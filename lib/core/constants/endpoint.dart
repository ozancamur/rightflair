enum Endpoint {
  
  CREATE_USER("create-user"),
  CHECK_USERNAME("check-username"),
  UPDATE_USER("update-user"),
  
  GET_USER("get-user"),
  GET_USER_POSTS("get-user-posts"),
  GET_USER_SAVES("get-user-saved-posts"),
  GET_USER_DRAFTS("get-user-draft"),

  GET_USER_STYLE_TAGS("get-user-style-tags"),
  UPDATE_USER_STYLE_TAGS("update-user-style-tags"),

  GET_USER_SETTINGS("get-user-settings"),
  UPDATE_USER_SETTINGS("update-user-settings"),

  ;

  final String value;
  const Endpoint(this.value);
}
