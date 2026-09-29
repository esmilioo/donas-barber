import 'package:go_router/go_router.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/booking',
    routes: [
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
    ],
  );
}
