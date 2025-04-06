import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isEmailValid = false;

  void validateEmail(String email) {
    setState(() {
      isEmailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$').hasMatch(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2F1), Color(0xFFE0E7FF)], // Light greenish to lavender
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          "lib/assets/logo.png",
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Back navigation
                    },
                    child: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    "Log in",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Email*",
                    emailController,
                    icon: isEmailValid ? Icons.check_circle : null,
                    iconColor: isEmailValid ? Colors.green : null,
                    onChanged: validateEmail,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Password*",
                    passwordController,
                    isPassword: true,
                    icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    iconColor: Colors.grey,
                    onTapIcon: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 65),
                    ),
                    onPressed: () {
                      // Handle login action
                    },
                    child: const Text("Log in", style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  const SizedBox(height: 15),

                  // Google Sign-In Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 65),
                    ),
                    onPressed: () {
                      // Handle Google login action
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Log in with Google",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    Color? iconColor,
    bool isPassword = false,
    Function(String)? onChanged,
    Function()? onTapIcon,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 75,
        child: TextField(
          controller: controller,
          obscureText: isPassword ? !isPasswordVisible : false,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            border: InputBorder.none,
            suffixIcon: icon != null
                ? IconButton(
                    icon: Icon(icon, color: iconColor),
                    onPressed: onTapIcon,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
