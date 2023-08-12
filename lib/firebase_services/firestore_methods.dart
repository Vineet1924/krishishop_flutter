import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User? auth = FirebaseAuth.instance.currentUser;
var uid = auth?.uid;
CollectionReference users = FirebaseFirestore.instance.collection('Users');

Future<void> addImage(String imageUrl) async {
  users
      .add({'profilepic': imageUrl})
      .then((value) => print("image updated"))
      .catchError((error) => print("Error occured"));
}

Future<void> addUsername(String username) async {
  users
      .add({'username': username})
      .then((value) => print("username updated"))
      .catchError((error) => print("Error occured"));
}

Future<void> addAddress(String address) async {
  users
      .add({'Address': address})
      .then((value) => print("address updated"))
      .catchError((error) => print("Error occured"));
}

Future<void> addEmail(String email) async {
  users
      .add({'email': email})
      .then((value) => print("email updated"))
      .catchError((error) => print("Error occured"));
}

Future<void> addPhone(String phone) async {
  users
      .add({'phone': phone})
      .then((value) => print("phone updated"))
      .catchError((error) => print("Error occured"));
}

Future<void> addUid(String uid) async {
  users
      .add({'userid': uid})
      .then((value) => print("userid added"))
      .catchError((error) => print("Error occured"));
}
