import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_/models/produk_model.dart';
import 'package:test_/models/user_model.dart';
import 'package:test_/pages/main_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final focusName = FocusNode();
  final focusEmail = FocusNode();
  final focusAlamat = FocusNode();
  final focusNoHp = FocusNode();
  final focusPassword = FocusNode();
  //
  final _nameController = TextEditingController();
  final _noHpController = TextEditingController();
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String pickedFile = '';
  bool isLoading = false;

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');
  Future<dynamic> register(String imageUrl, UserModel user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String message = '';
    dynamic data;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (userCredential.user != null) {
        //add user
        user.id = userCredential.user!.uid;
        await collection.doc(userCredential.user!.uid).set(user.toJson());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userPref', jsonEncode(user.toSharedPref()));
        prefs.setBool('loggedIn', true);
      }
      data = user;
      log(jsonEncode(data), name: 'data=user');
      message = 'Tambah User Sukses';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'email/password accounts are not enabled.';
      }
      data = null;
    }
    log(jsonEncode(data), name: 'data 69');
    log(message);
    Map<String, dynamic> response = {'data': data, 'message': message};
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5EC6F9),

      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      // extendBodyBehindAppBar: true,
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //nama
                const Text(
                  'Nama',
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
                  controller: _nameController,
                  focusNode: focusName,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Masukkan Nama';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Your Name',
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
                //email
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Masukkan Email';
                    }
                    return null;
                  },
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
                //no Hp
                const Text(
                  'No HP',
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
                  controller: _noHpController,
                  focusNode: focusNoHp,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Masukkan No HP';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Your Phone Number',
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
                //password
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
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Masukkan Password';
                    } else if (value.length < 6) {
                      return 'Minimal 6 karakter';
                    }
                    return null;
                  },
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
                  height: 10,
                ),
                //alamat
                const Text(
                  'Alamat',
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
                  controller: _alamatController,
                  focusNode: focusAlamat,
                  keyboardType: TextInputType.streetAddress,
                  maxLines: 2,
                  minLines: 2,
                  validator: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'Masukkan Alamat';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Your Address',
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
                  'Profile',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: pickedFile != ''
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: FileImage(
                                      File(
                                        pickedFile,
                                      ),
                                    ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  pickedFile = '';
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            )
                          ],
                        )
                      : IconButton(
                          onPressed: () {
                            _getImage(context);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      focusAlamat.unfocus();
                      focusEmail.unfocus();
                      focusName.unfocus();
                      focusNoHp.unfocus();
                      focusPassword.unfocus();

                      String imageUrl = '';

                      pickedFile != ''
                          ? imageUrl = await uploadFile(
                              _emailController.text.split('@')[0])
                          : imageUrl = '';
                      UserModel user = UserModel(
                        alamat: _alamatController.text,
                        email: _emailController.text,
                        name: _nameController.text,
                        noHp: _noHpController.text,
                        password: _passwordController.text,
                        profileUrl: imageUrl,
                      );

                      var response = await register(imageUrl, user);
                      isLoading = false;
                      setState(() {});
                      if (response['data'] != null) {
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                              (route) => false);
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
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String> uploadFile(String idUser) async {
    final path = 'images/$idUser';

    final file = File(pickedFile);

    final firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = firebaseStorageRef.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  _getImage(context) async {
    try {
      XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        pickedFile = pickedImage!.path;
      });
    } catch (e) {
      if (await reqPermission(Permission.storage) ==
          false | await Permission.photos.request().isDenied) {
        showAlertDialog(context);
      }
    }
  }
}

Future<bool> reqPermission(Permission permission) async {
  AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
  if (build.version.sdkInt >= 30) {
    var storageManagr = await Permission.manageExternalStorage.request();
    if (storageManagr.isGranted) {
      print('storageManagr isGranted');
      return true;
    } else {
      print('storageManagr isDenied');
      return false;
    }
  } else {
    if (await permission.isGranted) {
      print('isGranted');
      return true;
    } else {
      var result = await permission.request();
      if (result.isGranted) {
        print('result isGeanted');
        return true;
      } else {
        print('result isDenied');
        return false;
      }
    }
  }
}

showAlertDialog(context) => showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Allow Access to Camera and Gallery'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
