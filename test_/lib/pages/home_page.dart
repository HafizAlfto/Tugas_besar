import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_/models/produk_model.dart';
import 'package:test_/pages/checkout_page.dart';
import 'package:test_/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProdukModel> products = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  getProduct() async {
    isLoading = true;
    setState(() {});
    products = await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((value) =>
            value.docs.map((e) => ProdukModel.fromSnapshot(e)).toList());
    isLoading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5EC6F9),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Searching',
              hintStyle: const TextStyle(fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(35)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Popular Skincare',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : products.isEmpty
                  ? const Center(
                      child: Text('Data Tidak Ditemukan'),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 2.5,
                              childAspectRatio: 1 / 1.3,
                              crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  produk: products[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                    top: Radius.circular(30))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                    child: Image.asset(
                                      'assets/${products[index].image}',
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].nama!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        numberFormat
                                            .format(products[index].harga),
                                        style: const TextStyle(
                                            color: Color(0xFF5EC6F9),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
          // Expanded(
          //     child: SingleChildScrollView(
          //       child: Wrap(
          //         children: [
          //           ...List.generate(
          //               products.length,
          //               (index) => GestureDetector(
          //                     onTap: () {
          //                       Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                           builder: (context) => CheckoutPage(
          //                             produk: products[index],
          //                           ),
          //                         ),
          //                       );
          //                     },
          //                     child: Card(
          //                       shape: const RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.vertical(
          //                               bottom: Radius.circular(10),
          //                               top: Radius.circular(30))),
          //                       child: Column(
          //                         crossAxisAlignment:
          //                             CrossAxisAlignment.start,
          //                         children: [
          //                           ClipRRect(
          //                               clipBehavior: Clip.hardEdge,
          //                               borderRadius: const BorderRadius
          //                                   .vertical(
          //                                   top: Radius.circular(30)),
          //                               child: Image.asset(
          //                                 'assets/${products[index].image}',
          //                                 width: MediaQuery.of(context)
          //                                             .size
          //                                             .width /
          //                                         2.0 -
          //                                     20,
          //                               )),
          //                           Padding(
          //                             padding: const EdgeInsets.all(10),
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   products[index].nama!,
          //                                   maxLines: 1,
          //                                 ),
          //                                 Text(numberFormat.format(
          //                                     products[index].harga))
          //                               ],
          //                             ),
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   ))
          //         ],
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
