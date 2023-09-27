import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/categories_screen.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/dashboard_screens.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/orders_screens.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/products_screens.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/upload_screens.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/vendors_screens.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/withdrawal_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget _selectesItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case  DashboardScreen.routeName:
        setState(() {
          _selectesItem = DashboardScreen();
        });
        break;
      
      case  VendorScreen.routeName:
        setState(() {
          _selectesItem = VendorScreen();
        });
        break;
      
      case  ProductScreen.routeName:
        setState(() {
          _selectesItem = ProductScreen();
        });
        break;

      case  WithdrawalScreen.routeName:
        setState(() {
          _selectesItem = WithdrawalScreen();
        });
        break;

      case  UploadScreen.routeName:
        setState(() {
          _selectesItem = UploadScreen();
        });
        break;

      case  CategoryScreen.routeName:
        setState(() {
          _selectesItem = CategoryScreen();
        });
        break;

      case  OrdersScreen.routeName:
        setState(() {
          _selectesItem = OrdersScreen();
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Management'),
      ),
      sideBar: SideBar(
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: DashboardScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Vendors',
            icon: CupertinoIcons.person_3,
            route: VendorScreen.routeName
          ),
          AdminMenuItem(
            title: 'Withdrawal',
            icon: CupertinoIcons.money_dollar,
            route: WithdrawalScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Orders',
            icon: CupertinoIcons.shopping_cart,
            route: OrdersScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            route: CategoryScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Products',
            icon: Icons.shop,
            route: ProductScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            icon: CupertinoIcons.add,
            route: UploadScreen.routeName,
          )
        ], 
        selectedRoute: '', onSelected: (item) {
          screenSelector(item);
        },

        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              "Rijul's Book Panel",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),

        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'SideBar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      
      body: _selectesItem,
    );
  }
}