abstract class ApiEndpoints {
  static String login = "/auth/login";
  static String authGoogle = "/auth/google/mobile";
  static String registerUser = "/auth/register";
  static String sendEmailVerification = "/email/send-verification";
  static String verifyEmail = "/email/verify";
  static String refreshToken = "/auth/refreshToken";
  static String logout = "/auth/logout";
  static String editUserProfile = "/user/edit";
  static String getUserRoutes = "/route";
  static String createRoute = "/route";

  static String getRouteById(String id) => "/route/$id";
  static String updateRouteById(String id) => "/route/$id";
  static String deleteRouteById(String id) => "/route/$id";
}
