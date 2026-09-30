import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/booking/presentation/screens/booking_success_screen.dart';
import '../../features/booking/domain/entities/booking.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/shop/presentation/screens/shop_profile_screen.dart';
import '../../features/reviews/presentation/screens/reviews_screen.dart';
import '../../features/booking/presentation/screens/calendar_booking_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/booking', builder: (_, __) => const BookingScreen()),
      GoRoute(
        path: '/booking/success',
        builder: (_, state) =>
            BookingSuccessScreen(booking: state.extra as Booking),
      ),
      GoRoute(
        path: '/shop',
        builder: (_, __) => const ShopProfileScreen(),
      ),
      GoRoute(
        path: '/reviews',
        builder: (_, __) => const ReviewsScreen(),
      ),
      GoRoute(
        path: '/booking/calendar',
        builder: (_, state) => CalendarBookingScreen(
        barberId: state.uri.queryParameters['barberId'] ?? 'any',
        ),
      ),
      GoRoute(path: '/admin', builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(path: '/home', builder: (_, __) => const BookingScreen()),
    ],
  );
}