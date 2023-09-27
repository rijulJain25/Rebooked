import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/cart_provider.dart';
import 'package:rebooked_app/provider/product_provider.dart';
import 'package:rebooked_app/views/buyers/main_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_){
        return ProductProvider();
      }),
      ChangeNotifierProvider(create: (_){
        return CartProvider();
      })
    ],
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Brand-Bold',
        // backgroundColor: Color.fromARGB(255, 165, 245, 255),
        
      ),
      home: MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}

