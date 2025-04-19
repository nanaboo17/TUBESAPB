import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    try {
      // Check if the user already exists by signing in or checking for an existing user
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user != null) {
        // If user exists, just proceed with inserting the profile
        print('Existing User ID: ${user.id}');

        // Insert profile
        final insertResponse = await Supabase.instance.client
            .from('profiles')
            .insert({
          'id': user.id,  // Use the existing user.id
          'username': username,
          'created_at': DateTime.now().toIso8601String(),
        }).execute();

        if (insertResponse.error != null) {
          print('Insert Error: ${insertResponse.error!.message}');
        } else {
          print('User profile inserted successfully');
        }
      } else {
        // If user doesn't exist, proceed with sign up
        final signUpResponse = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );

        final newUser = signUpResponse.user;

        if (newUser != null) {
          print('New User ID: ${newUser.id}');

          // Insert profile for the new user
          final insertResponse = await Supabase.instance.client
              .from('profiles')
              .insert({
            'id': newUser.id,
            'username': username,
            'created_at': DateTime.now().toIso8601String(),
          }).execute();

          if (insertResponse.error != null) {
            print('Insert Error: ${insertResponse.error!.message}');
          } else {
            print('User profile inserted');
          }
        } else {
          print('User sign-up failed');
        }
      }
    } catch (e) {
      // Handle any errors that occur during registration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal daftar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDFCFB), Color(0xFFE2D1C3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset('assets/images/travel_kuy_logo.png', height: 180),
                    const SizedBox(height: 20),
                    Text(
                      "Buat Akun TravelKuy!",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Username Field
                    _buildInput(
                      controller: _usernameController,
                      icon: Icons.person,
                      hint: "Username",
                      validator: (v) => v!.isEmpty ? "Username wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildInput(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      hint: "Email",
                      validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    _buildInput(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      hint: "Password",
                      obscure: true,
                      validator: (v) => v!.length < 6
                          ? "Password minimal 6 karakter"
                          : null,
                    ),
                    const SizedBox(height: 30),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.brown.shade700,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("Daftar Sekarang"),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already have an account?
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sudah punya akun? Login",
                        style: GoogleFonts.poppins(
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.brown.shade400),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: GoogleFonts.poppins(),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

extension on PostgrestResponse {
  get error => null;
}
