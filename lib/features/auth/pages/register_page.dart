// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../providers/auth_provider.dart';

// class RegisterPage extends ConsumerStatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   ConsumerState<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends ConsumerState<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final _usernameController = TextEditingController();

//   final _emailController = TextEditingController();

//   final _passwordController = TextEditingController();

//   final _confirmPasswordController = TextEditingController();

//   bool _obscurePassword = true;

//   bool _obscureConfirmPassword = true;

//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> register() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await ref
//           .read(authProvider)
//           .register(
//             username: _usernameController.text.trim(),
//             email: _emailController.text.trim(),
//             password: _passwordController.text.trim(),
//           );

//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil")));

//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),

//         child: Form(
//           key: _formKey,

//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _usernameController,

//                 decoration: const InputDecoration(
//                   labelText: "Full Name",
//                   border: OutlineInputBorder(),
//                 ),

//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Nama wajib diisi";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _emailController,

//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),

//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Email wajib diisi";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _passwordController,

//                 obscureText: _obscurePassword,

//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   border: const OutlineInputBorder(),

//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),

//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),

//                 validator: (value) {
//                   if (value == null || value.length < 6) {
//                     return "Minimal 6 karakter";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _confirmPasswordController,

//                 obscureText: _obscureConfirmPassword,

//                 decoration: InputDecoration(
//                   labelText: "Konfirmasi Password",
//                   border: const OutlineInputBorder(),

//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureConfirmPassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                     ),

//                     onPressed: () {
//                       setState(() {
//                         _obscureConfirmPassword = !_obscureConfirmPassword;
//                       });
//                     },
//                   ),
//                 ),

//                 validator: (value) {
//                   if (value != _passwordController.text) {
//                     return "Password tidak sama";
//                   }

//                   return null;
//                 },
//               ),

//               const SizedBox(height: 24),

//               SizedBox(
//                 width: double.infinity,

//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : register,

//                   child: _isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text("Register"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';

import '../providers/auth_provider.dart';
import '../widgets/login_link.dart';
import '../widgets/register_form.dart';
import '../widgets/register_header.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider)
          .register(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      setState(() => _isLoading = false);
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
              const RegisterHeader(),

              RegisterForm(
                formKey: _formKey,

                usernameController: _usernameController,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,

                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,

                isLoading: _isLoading,

                onRegister: register,

                onTogglePassword: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },

                onToggleConfirmPassword: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.massive),

              LoginLink(
                onTap: () {
                  Navigator.pop(context);
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
