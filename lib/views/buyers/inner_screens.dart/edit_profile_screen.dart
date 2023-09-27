import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _fullNameController = new TextEditingController();

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _phoneController = new TextEditingController();

  String? address;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _fullNameController.text = widget.userData['fullName'];
      _emailController.text = widget.userData['email'];
      _phoneController.text = widget.userData['phoneNum'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            letterSpacing: 6,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
          
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.yellow.shade800,
                    ),
          
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: (){},
                        icon: Icon(CupertinoIcons.photo),
                      )
                    )
                  ],
                ),
          
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                    ) 
                  ),
                ),
          
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ) 
                  ),
                ),
          
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                    ) 
                  ),
                ),
          
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value){
                      address = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Address",
                    ) 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async{
            EasyLoading.show(status: "Updating");
            await _firestore.collection('buyers').doc(FirebaseAuth.instance.currentUser!.uid).update({
              'fullName': _fullNameController.text,
              'email': _emailController.text,
              'phoneNum': _phoneController.text,
              'address': address,
            }).whenComplete(() {
              EasyLoading.dismiss();
              Navigator.pop(context);
            });
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.yellow.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "UPDATE",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 7,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}