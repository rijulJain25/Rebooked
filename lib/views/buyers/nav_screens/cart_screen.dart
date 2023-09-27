import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/cart_provider.dart';
import 'package:rebooked_app/views/buyers/inner_screens.dart/checkout_screen.dart';
import 'package:rebooked_app/views/buyers/main_screen.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
        title: Text(
          "CART ITEMS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              _cartProvider.removeAllItem();
            }, 
            icon: Icon(CupertinoIcons.delete_solid), 
          )
        ],
      ),
      body: _cartProvider.getCartItem.isNotEmpty ? Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _cartProvider.getCartItem.length,
          itemBuilder: (context, index) {
            final cartData = _cartProvider.getCartItem.values.toList()[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
              child: Card(
                elevation: 4,
                color: Color.fromARGB(255, 244, 244, 244),
                child: SizedBox(
                  height: 186,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(cartData.imageUrlList[0]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 240,
                              child: Text(
                                cartData.productName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "₹ "+cartData.productPrice.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow.shade800,
                                letterSpacing: 5,
                              ),
                            ),
                            OutlinedButton(
                              onPressed: null, 
                              child: Text(
                                cartData.yearList,
                                style: TextStyle(
                                  color: Colors.yellow.shade800,
                                ),
                              ),
                              
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(7, 23),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(0),
                                  height: 40,
                                  width: 115,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade800,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: cartData.quantity == 1 ? null : (){
                                          _cartProvider.decrement(cartData);
                                        }, 
                                        icon: Icon(
                                          
                                          CupertinoIcons.minus,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      ),
                                      Text(
                                        (cartData.quantity).toStringAsFixed(0),
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: cartData.productQuantity == cartData.quantity ? null: (){
                                          _cartProvider.increment(cartData);
                                        }, 
                                        icon: Icon(
                                          
                                          CupertinoIcons.plus,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    _cartProvider.removeItem(cartData.productId);
                                  },
                                  color: Colors.yellow.shade800,
                                  icon: Icon(CupertinoIcons.delete),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
      : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Shopping cart is empty",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width-40,
              decoration: BoxDecoration(
                color: Colors.yellow.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context){
                      return MainScreen();
                    })
                  );
                },
                child: Center(
                  child: Text(
                    "CONTINUE SHOPPING",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )

          ],
        )
      ),

      bottomSheet: _cartProvider.totalPrice() == 0.00 ? Text("") : Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return CheckOutScreen();
            }));
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
                "₹"+_cartProvider.totalPrice().toStringAsFixed(2) + "   CHECK-OUT",
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
