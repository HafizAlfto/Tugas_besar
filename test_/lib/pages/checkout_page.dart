import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_/models/pesanan_model.dart';
import 'package:test_/models/produk_model.dart';
import 'package:test_/models/user_model.dart';
import 'package:test_/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutPage extends StatefulWidget {
  final ProdukModel produk;
  const CheckoutPage({super.key, required this.produk});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  UserModel? userModel;
  int jumlah = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5EC6F9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                color: const Color(0xFF5EC6F9),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Alamat Saya',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        userModel != null ? userModel!.name! : 'Nama user',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        userModel != null ? userModel!.noHp! : 'No Hp',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      Text(
                        userModel != null ? userModel!.alamat! : 'Alamat',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF5EC6F9),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/${widget.produk.image}'))),
                    ),
                    // CachedNetworkImage(
                    //   height: 100,
                    //   width: 100,
                    //   errorWidget: (context, url, error) =>
                    //       const Icon(Icons.error),
                    //   imageUrl: widget.produk.image!,
                    //   progressIndicatorBuilder: (context, url, progress) {
                    //     return Center(
                    //       child: CircularProgressIndicator(
                    //           value: progress.progress),
                    //     );
                    //   },
                    //   fit: BoxFit.fill,
                    // ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.produk.nama!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    jumlah > 1 ? jumlah-- : null;
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.remove)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '$jumlah',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () {
                                    jumlah++;
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.add)),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'Produk',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Text(
                            numberFormat.format(widget.produk.harga),
                            style: const TextStyle(
                                color: Color(0xFF5EC6F9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Pengiriman',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'J&T Express - D74298G5637',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Metode Pembayaran',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash On Delivery (COD)',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Total Harga'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              numberFormat.format(widget.produk.harga! * jumlah),
              style: const TextStyle(
                color: Color(0xFF5EC6F9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MaterialButton(
            height: 75,
            minWidth: 150,
            color: const Color(0xFF5EC6F9),
            textColor: Colors.white,
            onPressed: () {
              checkout();
              Navigator.pop(context);
              const SnackBar snackBar = SnackBar(
                elevation: 2,
                content: Text('Sukses Chckout!!!'),
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text(
              'Checkout',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  checkout() async {
    Timestamp time = Timestamp.now();
    PesananModel pesanan = PesananModel(
        produk: widget.produk,
        idUser: userModel!.id,
        time: time,
        jumlah: jumlah);
    var id = DateFormat('yyMMddHHmmss').format(time.toDate());

    FirebaseFirestore.instance
        .collection('pesanan')
        .doc(id)
        .set(pesanan.toJson());
  }
}
