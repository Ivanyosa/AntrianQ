import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_textfield.dart';
import '../../../core/widgets/primary_button.dart';

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;

  final VoidCallback onRegister;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.onRegister,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            controller: usernameController,
            hint: "Full Name",
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama wajib diisi";
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: emailController,
            hint: "Email",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
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
              if (value == null || value.length < 6) {
                return "Minimal 6 karakter";
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: confirmPasswordController,
            hint: "Confirm Password",
            prefixIcon: Icons.lock_outline,
            obscureText: obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: onToggleConfirmPassword,
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
            validator: (value) {
              if (value != passwordController.text) {
                return "Password tidak sama";
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.xxl),

          PrimaryButton(
            text: "Create Account",
            loading: isLoading,
            onPressed: onRegister,
          ),
        ],
      ),
    );
  }
}
