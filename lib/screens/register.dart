// screens/register_page.dart
import 'package:flutter/material.dart';
import 'package:schedu/widgets/header_auth.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  void _signup() {

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
                Row(
                  children: [                
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
                      child: Image.asset("assets/daun.png", width: 150),
                      
                    ),
                    
                  ],
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006565),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Nama",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      TextField(                
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
                      const SizedBox(height: 5),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      TextField(                
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "No Hp",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      TextField(                
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A959A),
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text("Sign Up",style: TextStyle(color: Colors.white),),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()));
                              
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
