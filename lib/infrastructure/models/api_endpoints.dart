abstract class ApiEndpoints {
  static String login = "/auth/login";
  static String authGoogle = "/auth/google/mobile";
  static String registerUser = "/auth/register";
  static String requestPasswordChange = "/auth/password-reset/request";
  static String verifyPasswordChange = "/auth/password-reset/confirm";
  static String sendEmailVerification = "/email/send-verification";
  static String verifyEmail = "/email/verify";
  static String refreshToken = "/auth/refreshToken";
  static String logout = "/auth/logout";
  static String editUserProfile = "/user/edit";
  static String getUserRoutes = "/route";
  static String createRoute = "/route";
  static String searchAddress = "/maps/findPlace";
  static String getReturnAddresses = "/ReturnAddress";
  static String createReturnAddress = "/ReturnAddress";
  static String generatePackagesReport = "/Reports/packages";
  static String shareRoute(String routeId) => "/share/$routeId";
  static String acceptSharedRoute(String sharedRouteId) =>
      "/share/accept/$sharedRouteId";

  static String getRouteById(String id) => "/route/$id";
  static String updateRouteById(String id) => "/route/$id";
  static String deleteRouteById(String id) => "/route/$id";
  static String getStopsByRoute(String routeId) => "/stop/$routeId";
  static String createStop(String id) => "/stop/$id";
  static String updateStop({required String routeId, required String stopId}) =>
      "/stop/$routeId/$stopId";
  static String deleteStop({required String routeId, required String stopId}) =>
      "/stop/$routeId/$stopId";
  static String updateReturnAddress(String id) => "/ReturnAddress/$id";
  static String deleteReturnAddress(String id) => "/ReturnAddress/$id";
  static String optimizeRoute(String routeId) =>
      "/Optimization/$routeId/optimize";
}
