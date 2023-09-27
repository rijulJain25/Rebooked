import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/product_provider.dart';
import 'package:intl/intl.dart';

class GeneralScreen extends StatefulWidget {
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];

  _getCategory() {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docs) {
        setState(() {
          _categoryList.add(docs['categoryName']);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _getCategory();
    super.initState();
  }

  String formatedDate(date){
    final outputDateFormate = DateFormat('dd/MM/yyyy');

    final outputDate = outputDateFormate.format(date);

    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: ((value) {
                  if(value!.isEmpty){
                    return 'Enter Product Name';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value) {
                  _productProvider.getFormData(productName: value);
                },
                decoration: InputDecoration(
                  labelText: "Enter Product Name",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: ((value) {
                  if(value!.isEmpty){
                    return 'Enter Product Price';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value) {
                  _productProvider.getFormData(
                      productPrice: double.parse(value));
                },
                decoration: InputDecoration(
                  labelText: "Enter Product Price",
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                validator: ((value) {
                  if(value!.isEmpty){
                    return 'Enter Product Quantity';
                  }else{
                    return null;
                  }
                }),
                onChanged: (value) {
                  _productProvider.getFormData(quantity: int.parse(value));
                },
                decoration: InputDecoration(
                  labelText: "Enter Product Quantity",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                hint: Text("Select Category"),
                items: _categoryList.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _productProvider.getFormData(category: value);
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                validator: ((value) {
                  if(value!.isEmpty){
                    return 'Enter Product Description';
                  }else{
                    return null;
                  }
                }),
                maxLines: 5,
                maxLength: 1000,
                onChanged: (value) {
                  _productProvider.getFormData(description: value);
                },
                decoration: InputDecoration(
                  labelText: "Enter Product Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: ButtonStyle(
              
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.yellow.shade800),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                    )
                                  )
                                ).copyWith(elevation:ButtonStyleButton.allOrNull(1)),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(5000),
                          ).then((value) {
                            setState(() {
                              _productProvider.getFormData(schedule: value);
                            });
                          });
                        },
                        child: Text("Schedule")
                    ),
                    if(_productProvider.productData['schedule'] != null)
                      Text(
                        formatedDate(_productProvider.productData['schedule']),
                      ),
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
