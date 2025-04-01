import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
            
                // Logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
            
                const SizedBox(height: 50),
            
                // Welcome Text
                const Text(
                  'Welcome back you\'ve been missed'
                ),
            
                const SizedBox(height: 25),
            
                // Email Field
                MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                ),
            
                const SizedBox(height: 50),

                // Password Field
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Password',
                    obscureText: true,
                ),

                const SizedBox(height: 50),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}