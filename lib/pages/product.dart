import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_training/widgets/ui_elements/title_default.dart';
import 'package:flutter_training/models/product.dart';

class ProductPage extends StatelessWidget {

  final Product product;

  ProductPage(this.product);

  void _showMap(){

  }

  Widget _buildAddressPriceRow(String address, double price) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        GestureDetector(
          onTap: _showMap,
          child: Text(
            address,
            style: TextStyle(fontFamily: "FFF_Tusj", color: Colors.grey),
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "|",
            style: TextStyle(color: Colors.grey),
          ),
        ),

        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: "FFF_Tusj", color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        print("Back button pressed");
        Navigator.pop(context, false);

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FadeInImage(
              image: NetworkImage(product.image),
              placeholder: AssetImage('assets/killer.jpg'),
              height: 300,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TitleDefault(product.title),
            ),
            _buildAddressPriceRow(product.location.address, product.price),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      )
    );
  }
}
