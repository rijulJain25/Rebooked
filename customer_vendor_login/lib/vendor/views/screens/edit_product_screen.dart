import 'package:flutter/material.dart';
import 'package:rebooked_app/vendor/views/screens/edit_products_tab/published_tab.dart';
import 'package:rebooked_app/vendor/views/screens/edit_products_tab/unpublished_tab.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade800,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "MANAGE PRODUCTS",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              letterSpacing: 7,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("Published"),
              ),
              Tab(
                child: Text('Unpublished'),
              )
            ],
          ),
        ),

        body: TabBarView(
          children: [
            PublishedTab(),
            UnpublishedTab(),
          ],
        ),
      )
    );
  }
}