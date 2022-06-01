class Globals {
  static String userName = '';
  static String userSurnames = '';
  static String userRole = '';

  static String getUserName() {
    return userName;
  }

  static String getUserSurnames() {
    return userSurnames;
  }

  static String getUserRole() {
    return userRole;
  }

  static setUserName(String value) {
    userName = value;
  }

  static setUserSurnames(String value) {
    userSurnames = value;
  }

  static setUserRole(String value) {
    userRole = value;
  }

  static getCompleteName() {
    return '$userName $userSurnames';
  }
}
