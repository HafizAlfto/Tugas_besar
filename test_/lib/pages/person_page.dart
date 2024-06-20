import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_/models/user_model.dart';
import 'package:test_/pages/login_page.dart';
import 'package:test_/pages/pesanan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  UserModel? userModel;
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userModel =
          UserModel.fromSharedPref(jsonDecode(prefs.getString('userPref')!));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userPref');
    prefs.setBool('loggedIn', false);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: userModel != null
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                // clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .45,
                    color: const Color(0xFF5EC6F9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: userModel!.profileUrl!,
                            progressIndicatorBuilder: (context, url, progress) {
                              print(userModel!.profileUrl!);
                              return Center(
                                child: CircularProgressIndicator(
                                    value: progress.progress),
                              );
                            },
                            fit: BoxFit.fill,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          userModel!.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userModel!.email!,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * .45 - 50,
                    left: 5,
                    right: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          surfaceTintColor: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                PersonItem(
                                  icon: Icons.location_on_rounded,
                                  text: 'Alamat Saya',
                                ),
                                Divider(),
                                PersonItem(
                                  icon: Icons.person_rounded,
                                  text: 'Akun Saya',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          surfaceTintColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('Status Pesanan');

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PesananPage(
                                                  idUser: userModel!.id!,
                                                )));
                                  },
                                  child: const PersonItem(
                                    icon: CupertinoIcons.cube_box,
                                    text: 'Status Pesanan',
                                  ),
                                ),
                                const Divider(),
                                const PersonItem(
                                  icon: Icons.lock,
                                  text: 'Ubah Password',
                                ),
                                const Divider(),
                                GestureDetector(
                                  onTap: () async {
                                    print('logout');
                                    logout();
                                  },
                                  child: const PersonItem(
                                    icon: Icons.logout_sharp,
                                    text: 'Keluar',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class PersonItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const PersonItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black.withOpacity(.6),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
