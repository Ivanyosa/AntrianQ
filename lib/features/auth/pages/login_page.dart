import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/services/fcm_service.dart';

import '../../admin/pages/admin_page.dart';
import '../../user/pages/user_page.dart';

import '../providers/auth_provider.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/register_link.dart';
import 'register_page.dart';

import 'package:flutter/foundation.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("STEP 1 : Login");

      await ref
          .read(authProvider)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      debugPrint("STEP 2 : Login Success");

      if (!kIsWeb) {
        debugPrint("STEP 3 : Initialize FCM");
        await FcmService().initialize();
      }

      debugPrint("STEP 4 : Get User Role");

      final role = await ref.read(authProvider).getUserRole();

      debugPrint("ROLE = $role");

      if (!mounted) return;

      debugPrint("STEP 5 : Navigate");

      if (role.trim().toLowerCase() == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserPage()),
        );
      }
    } catch (e, s) {
      debugPrint("ERROR = $e");
      debugPrint("$s");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const LoginHeader(),

              LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                obscurePassword: _obscurePassword,
                isLoading: _isLoading,
                onLogin: login,
                onTogglePassword: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.massive),

              RegisterLink(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
