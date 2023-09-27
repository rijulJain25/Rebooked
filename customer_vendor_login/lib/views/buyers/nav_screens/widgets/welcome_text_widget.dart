import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rebooked_app/views/buyers/nav_screens/cart_screen.dart';


class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 25, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Howdy, What Are You\n Looking For 👀",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CartScreen();
                }));
              },
              child: SvgPicture.asset(
                'assets/icons/cart.svg',
                width: 20,        
              ),
            ),
          )
        ],
      ),
    );
  }
}
