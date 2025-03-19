// lib/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signInEmailPassword() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final pass = _passController.text.trim();
    try {
      final user = await _authService.signInWithEmailPassword(email, pass);
      if (user != null) {
        // Перехід на ProfileScreen
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Не вдалося увійти. Перевірте дані.")),
        );
      }
    } catch (e) {
      print("Помилка входу (email/pass): $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInGoogle() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        // Користувач скасував
      }
    } catch (e) {
      print("Помилка Google Sign-In: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Помилка Google Sign-In: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизація (coachnewtool)"),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Поля для Email/Password
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passController,
                decoration: const InputDecoration(labelText: "Пароль"),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _signInEmailPassword,
                child: const Text("Увійти (Email/Password)"),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _signInGoogle,
                icon: const Icon(Icons.login),
                label: const Text("Увійти через Google"),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  // Перехід на екран реєстрації
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("Зареєструватися"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
