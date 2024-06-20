import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? noHp;
  String? password;
  String? alamat;
  String? profileUrl;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.noHp,
    this.alamat,
    this.profileUrl,
  });
  UserModel.fromSnapshot(DocumentSnapshot data) {
    id = data['id'] ?? '';
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    alamat = data['alamat'] ?? '';
    noHp = data['no_hp'] ?? '';
    password = data['password'] ?? '';
    profileUrl = data['profile_url'] ?? 'https://i.imgur.com/sUFH1Aq.png';
  }
  UserModel.fromQuerySnapshot(QueryDocumentSnapshot data) {
    id = data['id'] ?? '';
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    alamat = data['alamat'] ?? '';
    noHp = data['no_hp'] ?? '';
    password = data['password'] ?? '';
    profileUrl = data['profile_url'] ?? '';
  }
  UserModel.fromJson(Map<String, dynamic> data) {
    id = data['id'] ?? '';
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    alamat = data['alamat'] ?? '';
    noHp = data['no_hp'] ?? '';
    password = data['password'] ?? '';
    profileUrl = data['profile_url'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'alamat': alamat,
      'no_hp': noHp,
      'password': password,
      'profile_url': profileUrl,
    };
  }

  UserModel.fromSharedPref(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    email = data['email'];
    alamat = data['alamat'];
    noHp = data['no_hp'];
    password = data['password'];
    profileUrl = data['profile_url'];
  }
  Map<String, dynamic> toSharedPref() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'alamat': alamat,
      'no_hp': noHp,
      'password': password,
      'profile_url': profileUrl,
    };
  }
}
