import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedu/screens/register.dart';
import 'package:schedu/main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username == 'admin' && password == '1') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau Password salah')),
      );
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
                              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
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
                                        fontWeight: FontWeight.bold
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
                                        fontWeight: FontWeight.bold
                                        ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],                        
                        ),
                      ),
                      Spacer(),
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
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
                        "Username",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: usernameController,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A959A),
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text("Login",style: TextStyle(color: Colors.white),),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A959A),
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [                          
                            Text("Don't have a account?"),  
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RegisterPage() ),
                                );
                                
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )                        
                          ],                        
                        ),
                      ),
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
