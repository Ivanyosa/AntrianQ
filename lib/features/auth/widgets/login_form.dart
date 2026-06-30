import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/primary_button.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool obscurePassword;
  final bool isLoading;

  final VoidCallback onLogin;
  final VoidCallback onTogglePassword;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onLogin,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        children: [
          AppTextField(
            controller: emailController,
            hint: "Email",
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email wajib diisi";
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: passwordController,
            hint: "Password",
            prefixIcon: Icons.lock_outline,
            obscureText: obscurePassword,

            suffixIcon: IconButton(
              onPressed: onTogglePassword,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password wajib diisi";
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(text: "Login", loading: isLoading, onPressed: onLogin),
        ],
      ),
    );
  }
}
