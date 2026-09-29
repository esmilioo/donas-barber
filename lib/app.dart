import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class DonasBarberApp extends StatelessWidget {
  const DonasBarberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Dona's Barber",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}