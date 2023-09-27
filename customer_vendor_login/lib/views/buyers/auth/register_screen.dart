import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rebooked_app/controllers/auth_controller.dart';
import 'package:rebooked_app/utils/show_snackBar.dart';
import 'package:rebooked_app/views/buyers/auth/login_screen.dart';

import '../main_screen.dart';

class BuyerRegisterScreen extends StatefulWidget {

  @override
  State<BuyerRegisterScreen> createState() => _BuyerRegisterScreenState();
}

class _BuyerRegisterScreenState extends State<BuyerRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthControllers _authControllers = AuthControllers();

  late String email;

  late String fullName;

  late String phoneNum;

  late String password;

  bool _isLoading = false;

  Uint8List? _image;

  _signUpUsers() async{
    setState(() {
      _isLoading = true;
    });
    if(_formKey.currentState!.validate()){
      String res = await _authControllers.signUpUsers(email, fullName, phoneNum, password, _image!).whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
        });
      });
      if(res == "Success"){
        return Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (BuildContext context) {
          return MainScreen();
        })
        );
      }else{
        return showSnackBar(context, "There some error, Please try again!");
      }
      // return showSnackBar(context, "Congratulation! Account has been created");
    }else{
      setState(() {
        _isLoading = false;
      });
      print("Fields are not properly filled");
      return showSnackBar(context, "Fields must not be empty");
    }
  }

  selectGalleryImage() async{
    Uint8List im = await _authControllers.pickProfilImage(ImageSource.gallery);
    setState(() {
      _image= im;
    });
  }

  selectCameraImage() async{
    Uint8List im = await _authControllers.pickProfilImage(ImageSource.camera);  
    setState(() {
      _image= im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Customer's account",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Stack(
                  children:[ 
                    _image != null ? CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.yellow.shade800,
                      backgroundImage: MemoryImage(_image!),
                    ):
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.yellow.shade800,
                      backgroundImage: NetworkImage("https://i.pinimg.com/originals/ab/01/43/ab01437a16fdf57072342eb1a9bc303a.jpg"),
                    ),

                    Positioned(
                      right: 55,
                      top: 70,
                      child: IconButton(
                        onPressed: (){
                          selectGalleryImage();
                        }, 
                        icon: Icon(
                          CupertinoIcons.photo,
                          color: Colors.white,
                        ),
                      )
                    ),
                    Positioned(
                      right: 21,
                      top: 70,
                      child: IconButton(
                        onPressed: (){
                          selectCameraImage();
                        }, 
                        icon: Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                        ),
                      )
                    )
                  ]
                ),
                  
                Padding(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
                  child: TextFormField(
                    validator:(value) {
                      if(value!.isEmpty){
                        return "Name must not be empty";
                      }else{
                        return null;
                      }
                    },
                    onChanged:(value) {
                      fullName = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Full Name",
                    ),
                  ),
                ),
                  
                Padding(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
                  child: TextFormField(
                    validator:(value) {
                      if(value!.isEmpty){
                        return "Email must not be empty";
                      }else{
                        return null;
                      }
                    },
                    onChanged:(value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                ),
                  
                Padding(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
                  child: TextFormField(
                    validator:(value) {
                      if(value!.isEmpty){
                        return "Phone Number must not be empty";
                      }else{
                        return null;
                      }
                    },
                    onChanged:(value) {
                      phoneNum = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Phone Number",
                    ),
                  ),
                ),
                  
                Padding(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
                  child: TextFormField(
                    obscureText: true,
                    validator:(value) {
                      if(value!.isEmpty){
                        return "Password must not be empty";
                      }else{
                        return null;
                      }
                    },
                    onChanged:(value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ),
                  
                 SizedBox(
                  height: 20,
                ),
                
                GestureDetector(
                  onTap: (){
                    _signUpUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width-45,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isLoading ? CircularProgressIndicator(
                        color: Colors.white,
                      ) : Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account?"),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return LoginScreen();
                          })
                        );
                      }, 
                      child: Text("Login"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}