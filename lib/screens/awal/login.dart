import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedu/screens/awal/register.dart';
import 'package:schedu/main.dart';
import 'lupapassword.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      await user?.reload();

      if (!mounted) return;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Silakan verifikasi email Anda terlebih dahulu."),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainPage()));
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan';
      if (e.code == 'user-not-found') {
        message = 'Pengguna tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e, stacktrace) {
      print("Unhandled error: $e");
      print("Stacktrace: $stacktrace");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFF2FD4DB),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcATop,
                              ),
                              child: Image.asset("assets/daun.png", width: 150),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 17.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "Hello !",
                                      style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "Welcome to Schedu",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcATop,
                        ),
                        child: Image.asset("assets/task.png", width: 150),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006565),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Password",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LupapasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0A959A),
                                  shape: const StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A959A),
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
