import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  String? name;
  TextEditingController? nameTextCtrl;
  String? email;
  TextEditingController? emailTextCtrl;
  String? dob;
  TextEditingController? dobTextCtrl;
  String? phone;
  TextEditingController? phoneTextCtrl;
  TextEditingController? phoneTextCtrl2;
  String? imageLink;

  UserModel(
      {this.name,
      this.nameTextCtrl,
      this.email,
      this.emailTextCtrl,
      this.dob,
      this.dobTextCtrl,
      this.phone,
      this.phoneTextCtrl,
      this.phoneTextCtrl2,
      this.imageLink});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    phone = json['phone'];
  }

  UserModel.fromObject(DocumentSnapshot<Object?> object) {
    imageLink = object.get("imageLink");
    name = object.get("name");
    email = object.get("email");
    dob = object.get("dob");
    phone = object.get("phone");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['email'] = email;
    data['dob'] = dob;
    data['phone'] = phone;
    return data;
  }

  Map<String, dynamic> formData() {
    final Map<String, dynamic> data = {};
    data['name'] = nameTextCtrl?.text;
    data['email'] = emailTextCtrl?.text;
    data['dob'] = dobTextCtrl?.text;
    data['phone'] = phoneTextCtrl?.text;
    data['imageLink'] = imageLink;
    return data;
  }
}
