import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rebooked_app/views/buyers/auth/login_screen.dart';
import 'package:rebooked_app/views/buyers/inner_screens.dart/edit_profile_screen.dart';
import 'package:rebooked_app/views/buyers/inner_screens.dart/order_screen.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return _auth.currentUser == null ? 

      Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Colors.yellow.shade800,
              title: Text(
                "Profile",
                style: TextStyle(
                  letterSpacing: 4,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.star),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.yellow.shade800,
                    backgroundImage: NetworkImage("https://i.pinimg.com/originals/ab/01/43/ab01437a16fdf57072342eb1a9bc303a.jpg"),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hey! Login to Order",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context){
                        return LoginScreen();
                      })
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Log-In/Sign-In",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  )
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                    
                  ),
                ),
              ],
            ),
          )
    
    : FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Colors.yellow.shade800,
              title: Text(
                "Profile",
                style: TextStyle(
                  letterSpacing: 4,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.star),
                )
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.yellow.shade800,
                    backgroundImage: NetworkImage(data['profileImage']),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['fullName'].toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['email'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context){
                        return EditProfileScreen(userData: data,);
                      })
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Edit  profile",
                      style: TextStyle(
                        fontSize: 17
                      ),
                    ),
                  )
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                    
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Phone"),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Cart"),
                ),
                ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) {
                      return CustomerOrderScreen();
                    },));
                  },
                  leading: Icon(Icons.attach_money),
                  title: Text("Orders"),
                ),
                ListTile(
                  onTap: () async{
                    await _auth.signOut().whenComplete(() {
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context){
                        return LoginScreen();
                      })
                      );
                    });
                  },
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ],
            ),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
