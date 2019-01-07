import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_training/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/scoped_models/products.dart';

class ProductPage extends StatelessWidget {

  final int productPosition;

  ProductPage(this.productPosition);

  void _showWarningDialog(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text("This action cannot be undone!"),
            actions: <Widget>[
              FlatButton(
                child: Text("DISCARD"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("CONTINUE"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        }
    );
  }

  Widget _buildAddressPriceRow(Product product){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Union Square, San Francisco",
          style: TextStyle(
              fontFamily: "FFF_Tusj",
              color: Colors.grey
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
          product.price.toString(),
          style: TextStyle(
              fontFamily: "FFF_Tusj",
              color: Colors.grey
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        print("Back button pressed");
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant(builder: (BuildContext context, Widget child, ProductsModel model){
        final Product product = model.products[productPosition];
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(product.image),
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
        );
      })
    );
  }
}