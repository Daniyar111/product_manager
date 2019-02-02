import 'package:flutter/material.dart';
import 'package:flutter_training/widgets/products/price_tag.dart';
import 'dart:async';
import 'package:flutter_training/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/scoped_models/main.dart';

class ProductPage extends StatelessWidget {

  final Product product;

  ProductPage(this.product);

  Widget _buildAddressPriceRow(Product product) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text(
          "Union Square, San Francisco",
          style: TextStyle(fontFamily: "FFF_Tusj", color: Colors.grey),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            "|",
            style: TextStyle(color: Colors.grey),
          ),
        ),

        Text(
          product.price.toString(),
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
            _buildAddressPriceRow(product),
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
