import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rebooked_app/utils/show_snackBar.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetailScreen({super.key, required this.productData});

  @override
  State<VendorProductDetailScreen> createState() => _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _publisherNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _publisherNameController.text = widget.productData['publisherName'];
      _quantityController.text = widget.productData['quantity'].toString();
      _productPriceController.text = widget.productData['productPrice'].toString();
      _productDescriptionController.text = widget.productData['description'];
      _categoryController.text = widget.productData['category'];
    });
    super.initState();
  }

  double? productPrice;
  int? productQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow.shade800,
        title: Text(
          widget.productData['productName']
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                ),
              ),
      
              SizedBox(
                height: 17,
              ),
      
              TextFormField(
                controller: _publisherNameController,
                decoration: InputDecoration(
                  labelText: "Author Name",
                ),
              ),
      
              SizedBox(
                height: 17,
              ),
      
              TextFormField(
                onChanged: (value) {
                  productQuantity = int.parse(value);
                },
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: "Available Quantity",
                ),
              ),
      
              SizedBox(
                height: 17,
              ),
      
              TextFormField(
                onChanged: (value) {
                  productPrice = double.parse(value);
                },
                controller: _productPriceController,
                decoration: InputDecoration(
                  labelText: "Product Price",
                ),
              ),
      
              SizedBox(
                height: 17,
              ),
      
              TextFormField(
                controller: _productDescriptionController,
                maxLines: 4,
                maxLength: 1000,
                decoration: InputDecoration(
                  labelText: "Product Description",
                ),
              ),
      
              SizedBox(
                height: 17,
              ),
      
              TextFormField(
                controller: _categoryController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Category",
                ),
              ),
            ],
          ),
        ),
      ),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async{
            if(productPrice != null && productQuantity!= null){
              EasyLoading.show(status: "Updating");
              await _firestore.collection('products').doc(widget.productData['productId']).update({
              'productName': _productNameController.text,
              'publisherName': _publisherNameController.text,
              'quantity': productQuantity,
              'productPrice': productPrice,
              'description': _productDescriptionController.text,
              'category': _categoryController.text,
            }).whenComplete(() {
              EasyLoading.dismiss();
            });
            }else{
              showSnackBar(context, "Update Quantity and Price");
            }
            
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
                "UPDATE DETAILS",
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