import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/signup-succesfull',
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
