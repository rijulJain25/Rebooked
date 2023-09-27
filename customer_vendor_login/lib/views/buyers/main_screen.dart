import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rebooked_app/views/buyers/nav_screens/account_screen.dart';
import 'package:rebooked_app/views/buyers/nav_screens/cart_screen.dart';
import 'package:rebooked_app/views/buyers/nav_screens/catergory_screen.dart';
import 'package:rebooked_app/views/buyers/nav_screens/home_screen.dart';
import 'package:rebooked_app/views/buyers/nav_screens/search_screen.dart';
import 'package:rebooked_app/views/buyers/nav_screens/store_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    CatergoryScreen(),
    StoreScreen(),
    CartScreen(),
    SearchScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        
        unselectedItemColor: Colors.black,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex= value;
          });
        },
        selectedItemColor: Colors.yellow[800],
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home), 
            label: 'HOME'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/explore.svg'), 
            label: 'CATEGORIES'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/shop.svg'), 
            label: 'SHOP'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/cart.svg'), 
            label: 'CART'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/search.svg'),
            label: 'SEARCH'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/account.svg'),
            label: 'ACCOUNT'
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}