import 'package:flutter/material.dart';
import 'package:rebooked_app/controllers/auth_controller.dart';
import 'package:rebooked_app/utils/show_snackBar.dart';
import 'package:rebooked_app/vendor/views/auth/vendor_auth_screen.dart';
import 'package:rebooked_app/views/buyers/auth/register_screen.dart';
import 'package:rebooked_app/views/buyers/main_screen.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthControllers _authControllers = AuthControllers();
  late String email;

  late String password;
  bool _isLoading = false;

  _loginUsers() async{
    setState(() {
      _isLoading = true;
    });
    if(_formKey.currentState!.validate()){
      String res = await _authControllers.loginUsers(
        email, 
        password,
      );
      if(res == 'Success'){
        return Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (BuildContext context) {
          return MainScreen();
        })
      );
      }else{
        setState(() {
          _isLoading= false;
        });
        return showSnackBar(context, "Invalid Credintial");
      }
    }else{
      setState(() {
          _isLoading= false;
        });
      return showSnackBar(context, "Fields must not be empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login Customer's account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          
                Padding(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
                  child: TextFormField(
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Email is mandatory";
                      }else{
                        return null;
                      }
                    },
                    onChanged:(value) {
                      email= value;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                    ),
                  ),
                ),
          
                Padding(
                  padding: const EdgeInsets.fromLTRB(21, 12, 21, 12),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Password is mandatory";
                      }else{
                        return null;
                      }
                    },
                    onChanged:(value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                    ),
                  ),
                ),
          
                SizedBox(
                  height: 20,
                ),
          
                InkWell(
                  onTap:() {
                    _loginUsers();
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
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                      ),
                    ),
                  ),
                ),
      
               
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
                        child: SocialLoginButton(
                          borderRadius: 10,
                          buttonType: SocialLoginButtonType.google, 
                          onPressed: (){}
                        ),
                      ),
      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                        child: SocialLoginButton(
                          borderRadius: 10,
                          buttonType: SocialLoginButtonType.facebook, 
                          onPressed: (){}
                        ),
                      ),
                  
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return BuyerRegisterScreen();
                            })
                          );
                      }, 
                      child: Text("Register"),
                    ),
                  ],
                ),
      
                OutlinedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context){
                        return VendorAuthScreen();
                      })
                    );
                  }, 
                  child: Text(
                    "LOGIN AS VENDOR",
                  )
                )
          
              ],
            ),
          )
        ),
      ),
    );
  }
}