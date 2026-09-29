import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../widgets/social_button.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _run(Future<void> Function() task) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await task();
      if (!mounted) return;
      final email = _auth.currentUser?.email;
      if (_auth.isAdminEmail(email)) {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    } catch (e) {
      setState(() => _error = e.toString().split(']').last.trim());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.content_cut_rounded,
                    size: 36, color: AppColors.onAccent),
              ),
              const SizedBox(height: 24),
              const Text("Bentornato",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.8)),
              const SizedBox(height: 8),
              const Text('Accedi per gestire i tuoi appuntamenti',
                  style: TextStyle(
                      fontSize: 15, color: AppColors.textSecondary)),
              const SizedBox(height: 32),

              SocialButton(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continua con Google',
                onTap: () => _run(() => _auth.signInWithGoogle()),
              ),
              const SizedBox(height: 12),
              SocialButton(
                icon: Icons.apple_rounded,
                label: 'Continua con Apple',
                onTap: () => _run(() => _auth.signInWithApple()),
              ),
              const SizedBox(height: 24),

              Row(children: const [
                Expanded(child: Divider(color: AppColors.border)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('oppure',
                        style: TextStyle(color: AppColors.textMuted))),
                Expanded(child: Divider(color: AppColors.border)),
              ]),
              const SizedBox(height: 24),

              AuthTextField(
                controller: _emailCtrl,
                hint: 'Email',
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AuthTextField(
                controller: _pwdCtrl,
                hint: 'Password',
                obscure: true,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: const TextStyle(
                        color: AppColors.danger, fontSize: 13)),
              ],
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () => _run(() => _auth.signInWithEmail(
                        _emailCtrl.text.trim(), _pwdCtrl.text)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  disabledBackgroundColor: AppColors.cardElevated,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onAccent))
                    : const Text('Accedi con Email',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('Non hai un account? Registrati',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}