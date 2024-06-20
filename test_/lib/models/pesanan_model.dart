import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_/models/produk_model.dart';

class PesananModel {
  ProdukModel? produk;
  String? idUser;
  int? jumlah;
  Timestamp? time;
  PesananModel(
      {required this.produk,
      required this.jumlah,
      required this.idUser,
      required this.time});
  PesananModel.fromSnapshot(DocumentSnapshot snapshot) {
    produk = ProdukModel.fromJson(snapshot['produk']);
    idUser = snapshot['id_user'];
    time = snapshot['time'];
    jumlah = snapshot['jumlah'];
  }
  Map<String, dynamic> toJson() {
    return {
      'produk': produk!.toJson(),
      'id_user': idUser,
      'time': time,
      'jumlah': jumlah
    };
  }
}
