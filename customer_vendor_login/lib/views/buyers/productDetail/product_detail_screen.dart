import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/cart_provider.dart';
import 'package:rebooked_app/utils/show_snackBar.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;

  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.productData['productName'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: PhotoView(
                        backgroundDecoration: BoxDecoration(
                          // color: Colors.yellow.shade800,
                          image: DecorationImage(
                            opacity: 0.3,
                            image: NetworkImage(
                            widget.productData['imageUrlList'][0]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        imageProvider: NetworkImage(
                            widget.productData['imageUrlList'][_imageIndex]),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          width: 70,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: widget.productData['imageUrlList'].length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _imageIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.yellow.shade800.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.yellow.shade800,
                                          )),
                                      height: 60,
                                      width: 60,
                                      child: Image.network(widget
                                          .productData['imageUrlList'][index]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "₹ " + widget.productData['productPrice'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 6,
                  color: Colors.yellow.shade800,
                ),
              ),
              
              Text(
                widget.productData['productName'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 6,
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Author: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    widget.productData['publisherName'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    height: 70,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // color: Color.fromARGB(255, 237, 237, 237),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.yellow.shade800),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.delivery_dining_outlined,
                          color: Colors.yellow.shade800,
                        ),
                        Text(
                          "Free Ship",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 70,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // color: Colors.yellow.shade800.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.yellow.shade800),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.replay_10_outlined,
                          color: Colors.yellow.shade800,
                        ),
                        Text(
                          "Return",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 70,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // color: Colors.yellow.shade800.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.yellow.shade800),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.discount_outlined,
                          color: Colors.yellow.shade800,
                        ),
                        Text(
                          "50% Off",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
        
              SizedBox(
                height: 20,
              ),
        
              Container(
                margin: EdgeInsets.fromLTRB(13, 2, 13, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 237, 237, 237),
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product's Description",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                        Text(
                          "View More",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          widget.productData['description'],
                          style: TextStyle(
                            color: Color.fromARGB(255, 91, 91, 91)
                          ),          
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
              ),
        
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13, 2, 13, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 237, 237, 237),
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Available Prints",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                        Text(
                          "View Years",
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['yearList'].length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: _selectedYear == widget.productData['yearList'][index] ? Colors.yellow.shade800 : null,
                                child: OutlinedButton(
                                  onPressed: (){
                                    setState(() {
                                      _selectedYear = widget.productData['yearList'][index];
                                    });
                                    print(_selectedYear);
                                  },
                                  child: Text(
                                    widget.productData['yearList'][index],
                                    style: TextStyle(
                                      color: _selectedYear == widget.productData['yearList'][index] ? Colors.white : Colors.yellow.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13, 2, 13, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width)/2-15,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow.shade800),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Shipping charges: "+ widget.productData['shippingCharge'].toString(),
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width)/2-15,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow.shade800),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "In Stock: "+ widget.productData['quantity'].toString(),
                          style: TextStyle(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: _cartProvider.getCartItem.containsKey(widget.productData['productId'])? null: (){
            if(_selectedYear == null){
              return showSnackBar(context, "Please Select Print Year");
            }else{
              _cartProvider.addProductToCart(
              widget.productData['productName'], 
              widget.productData['productId'], 
              widget.productData['imageUrlList'], 
              1,
              widget.productData['quantity'],
              widget.productData['productPrice'],
              widget.productData['vendorId'], 
              _selectedYear!,
              widget.productData['schedule']);
              return showSnackBar(context, "Item Added Successfully");
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _cartProvider.getCartItem.containsKey(widget.productData['productId'])? Colors.grey : Colors.yellow.shade800,
              borderRadius: BorderRadius.circular(10),         
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.cart_fill_badge_plus,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                _cartProvider.getCartItem.containsKey(widget.productData['productId'])?
                Text(
                  "IN-CART",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 4
                  ),
                )
                 : Text(
                  "ADD TO CART",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 4
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
