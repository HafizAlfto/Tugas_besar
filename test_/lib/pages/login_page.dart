import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_/models/produk_model.dart';
import 'package:test_/models/user_model.dart';
import 'package:test_/pages/main_page.dart';
import 'package:test_/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<dynamic> login() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String message = '';
    dynamic data;
    isLoading = true;
    setState(() {});
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (userCredential.user != null) {
        data = await FirebaseFirestore.instance
            .collection('user')
            .where('id', isEqualTo: userCredential.user!.uid)
            .get()
            .then((value) => UserModel.fromSnapshot(value.docs.first));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userPref', jsonEncode(data.toSharedPref()));
        prefs.setBool('loggedIn', true);
      }
      message = 'Login Suksess';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = e.code;
      }
      data = null;
    }
    isLoading = false;
    setState(() {});
    Map<String, dynamic> response = {'data': data, 'message': message};

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5EC6F9),
      body: Column(
        children: [
          const Spacer(),
          const Text(
            'Welcome to Our Store',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            'assets/LOGO FBM Beaute.png',
            width: MediaQuery.of(context).size.width / 2,
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _emailController,
                    focusNode: focusEmail,
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Masukkan Email Anda';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Your Email',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: focusPassword,
                    validator: (value) {
                      if (value!.isEmpty || value == '') {
                        return 'Masukkan Password Anda';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Your Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        var response = await login();
                        if (response['data'] != null) {
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                                (route) => false);
                          }
                        } else {
                          final SnackBar snackBar = SnackBar(
                            elevation: 2,
                            content: Text(response['message']!),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                          child: isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Loading',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Belum Punya Akunn?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                              child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          )))),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       for (var i = 0; i < images.length; i++) {
                  //         FirebaseFirestore.instance
                  //             .collection('products')
                  //             .add(images[i].toJson());
                  //         print(images[i].nama);
                  //       }
                  //     },
                  //     child: const Text('images'))
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

List<ProdukModel> images = [
  ProdukModel(
      nama: 'Barrier Repair',
      harga: 270000,
      deskripsi: 'deskripsi',
      image: 'barrier repair.png'),
  ProdukModel(
      nama: 'The Originote Serum',
      harga: 42000,
      deskripsi: 'deskripsi',
      image: 'the originote serum.png'),
  ProdukModel(
      nama: 'Skintific Sunscreen',
      harga: 85000,
      deskripsi: 'deskripsi',
      image: 'skintific sunscreen.png'),
  ProdukModel(
      nama: 'Glad2Glow Moist',
      harga: 86000,
      deskripsi: 'deskripsi',
      image: 'glad2glow moist.png'),
  ProdukModel(
      nama: 'The Originote Toner',
      harga: 42000,
      deskripsi: 'deskripsi',
      image: 'the originote toner.png'),
  ProdukModel(
      nama: 'The Originote Moist',
      harga: 44000,
      deskripsi: 'deskripsi',
      image: 'the originote moist.png'),
  ProdukModel(
      nama: 'Scarlett Serum',
      harga: 85000,
      deskripsi: 'deskripsi',
      image: 'scarlett serum.png'),
  ProdukModel(
      nama: 'Sunscreen Facetology',
      harga: 85000,
      deskripsi: 'deskripsi',
      image: 'sunscreen facetology.png'),
  ProdukModel(
      nama: 'Lacoco Serum',
      harga: 85000,
      deskripsi: 'deskripsi',
      image: 'lacoco serum.png'),
  //
];
