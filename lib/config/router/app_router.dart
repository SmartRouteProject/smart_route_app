import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';
import 'package:smart_route_app/presentation/widgets/widgets.dart';
import 'package:smart_route_app/infrastructure/mocks/stops_sample.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      name: SignupScreen.name,
      builder: (context, state) {
        return SignupScreen();
      },
    ),
    GoRoute(
      path: '/signup-succesfull',
      name: SuccesfulSignupScreen.name,
      builder: (context, state) {
        return SuccesfulSignupScreen();
      },
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [],
    ),
  ],
);
