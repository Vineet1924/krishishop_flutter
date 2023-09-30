// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class userModel {
  String? address;
  String? email;
  String? phone;
  String? profilepic;
  String? uid;
  String? username;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  userModel({
    required this.address,
    required this.email,
    required this.phone,
    required this.profilepic,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> addressMap() {
    return {"address": address};
  }

  Map<String, dynamic> emailMap() {
    return {"email": email};
  }

  Map<String, dynamic> phoneMap() {
    return {"phone": phone};
  }

  Map<String, dynamic> profilepicMap() {
    return {"profilepic": profilepic};
  }

  Map<String, dynamic> usernameMap() {
    return {"username": username};
  }

  Map<String, dynamic> uidMap() {
    return {"uid": uid};
  }

  Future<void> storeAddress() async {
    try {
      await usersCollection.doc(uid).set(addressMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeEmail() async {
    try {
      await usersCollection.doc(uid).set(emailMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storePhone() async {
    try {
      await usersCollection.doc(uid).set(phoneMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeProfilepic() async {
    try {
      await usersCollection
          .doc(uid)
          .set(profilepicMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeUsername() async {
    try {
      await usersCollection
          .doc(uid)
          .set(usernameMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  Future<void> storeUid() async {
    try {
      await usersCollection.doc(uid).set(uidMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error while storing data: $e");
    }
  }

  factory userModel.fromMap(Map<String, dynamic> map) {
    return userModel(
      uid: map['uid'],
      address: map['address'],
      email: map['email'],
      phone: map['phone'],
      profilepic: map['profilepic'],
      username: map['username'],
    );
  }

  static Future<userModel> getUserData(String uid) async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection("Users").doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    if (userDocSnapshot.exists) {
      Map<String, dynamic> userData =
          userDocSnapshot.data() as Map<String, dynamic>;

      String username = userData['username'] ?? '';
      String address = userData['address'] ?? '';
      String email = userData['email'] ?? '';
      String phone = userData['phone'] ?? '';
      String profilepic = userData['profilepic'] ?? '';
      String uid = userData['uid'] ?? '';

      return userModel(
        username: username,
        address: address,
        email: email,
        phone: phone,
        profilepic: profilepic,
        uid: uid,
      );
    } else {
      return userModel(
        username: '',
        address: '',
        email: '',
        phone: '',
        profilepic: '',
        uid: '',
      );
    }
  }
}
