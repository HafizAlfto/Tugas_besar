import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_/models/pesanan_model.dart';
import 'package:test_/models/produk_model.dart';
import 'package:test_/utils.dart';

class PesananPage extends StatefulWidget {
  final String idUser;
  const PesananPage({super.key, required this.idUser});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  bool isLoading = true;
  List<PesananModel> pesanan = [];
  List<Map<String, dynamic>> newPesanan = [];
  getData() async {
    isLoading = true;
    setState(() {});
    pesanan = await FirebaseFirestore.instance
        .collection('pesanan')
        .get()
        .then((value) => value.docs
            .map((e) => PesananModel.fromSnapshot(e)
                //  {
                //       if (widget.idUser == e['id_user']) {
                // print(e['id_user']);
                // print(e['produk']);
                // print(e['time'].toString());
                // print(e);
                // print('prouk');
                // ProdukModel produk = ProdukModel.fromJson(e['produk']);
                // print(produk);
                // print('data');
                // PesananModel data = PesananModel.fromSnapshot(e);
                // print('dataaa');
                // pesanan.add(data);
                // return PesananModel(
                //     produk: ProdukModel.fromSnapshot(e['produk']),
                //     idUser: e['id_user'],
                //     time: e['time']);

                //   }
                //   return null;
                // }
                )
            .toList());
    pesanan =
        pesanan.where((element) => element.idUser == widget.idUser).toList();
    pesanan.sort((a, b) => b.time!.compareTo(a.time!));
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Pesanan'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5EC6F9),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pesanan.isEmpty
              ? const Center(
                  child: Text(
                    'Belum Ada Pesanan',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    ...List.generate(
                        pesanan.length,
                        (index) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: const Color(0xFF5EC6F9),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      'assets/${pesanan[index].produk!.image}'))),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pesanan[index].produk!.nama!,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${pesanan[index].jumlah} Produk',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'Total Harga ${numberFormat.format(pesanan[index].produk!.harga! * pesanan[index].jumlah!)}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                            shape: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide.none),
                                            color: const Color(0xFF5EC6F9),
                                            textColor: Colors.white,
                                            onPressed: () {},
                                            child:
                                                const Text('Sedang Diproses')),
                                        MaterialButton(
                                            shape: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide.none),
                                            // color: Colors.blue,
                                            textColor: Colors.black,
                                            onPressed: () {},
                                            child: const Text(
                                                'Pesanan Sedang Dikirim')),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))
                  ],
                ),
    );
  }
}
