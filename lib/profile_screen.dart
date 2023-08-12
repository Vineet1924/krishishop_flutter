import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishishop/components/icon_tile.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/components/my_snackbar.dart';
import 'package:krishishop/firebase_services/firestore_methods.dart';
import 'components/my_textfield.dart';
import 'firebase_services/firebase_auth_methods.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  User? auth = FirebaseAuth.instance.currentUser;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String imageLink = "";

  Future signOut() async {
    await EasyLoading.show(status: 'Loging out...');
    await FirebaseAuthMethods(FirebaseAuth.instance).logOut(context: context);
    await EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 270,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                      color: Colors.white, width: 4)),
                              child: Image.asset(
                                "assets/images/user.png",
                                height: 120,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? image = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                          if (image == null) {
                            showErrorSnackBar(context, "No image selected");
                          } else {
                            print("${image.path}");
                            print("${image.name}");

                            Reference root = FirebaseStorage.instance.ref();
                            Reference profile = root.child('profile');
                            Reference imageToUpload =
                                profile.child('${image.name}');
                            try {
                              EasyLoading.show(status: "Uploading");
                              await imageToUpload.putFile(File(image.path));
                              EasyLoading.showSuccess("Uploaded");
                              imageLink = await imageToUpload.getDownloadURL();
                              await addImage(imageLink);
                              EasyLoading.dismiss();
                            } on Exception catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Username",
                      style:
                          TextStyle(fontSize: 24, color: Colors.grey.shade100),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: usernameController,
                            hintText: "Username",
                            obscureText: false,
                            inputType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: GestureDetector(
                              onTap: () {
                                addImage(imageLink);
                              },
                              child: iconTile(icon: Icon(Icons.edit))),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: addressController,
                            hintText: "Address",
                            obscureText: false,
                            inputType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: iconTile(icon: Icon(Icons.edit)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: phoneController,
                            hintText: "Phone",
                            obscureText: false,
                            inputType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: iconTile(icon: Icon(Icons.edit)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MyButton(
                      onTap: signOut,
                      title: "Logout",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
