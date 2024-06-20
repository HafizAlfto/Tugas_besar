import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukModel {
  String? nama;
  int? harga;
  String? deskripsi;
  String? image;

  ProdukModel(
      {required this.nama,
      required this.harga,
      required this.deskripsi,
      required this.image});
  ProdukModel.fromSnapshot(DocumentSnapshot snapshot) {
    nama = snapshot['nama'];
    harga = snapshot['harga'];
    image = snapshot['image'];
    deskripsi = snapshot['deskripsi'];
  }
  ProdukModel.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    harga = json['harga'];
    image = json['image'];
    deskripsi = json['deskripsi'];
  }
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'image': image,
      'harga': harga,
      'deskripsi': deskripsi,
    };
  }
}
