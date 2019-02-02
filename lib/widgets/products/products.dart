import 'package:flutter/material.dart';
import 'package:flutter_training/widgets/products/product_card.dart';
import 'package:flutter_training/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/scoped_models/main.dart';


class Products extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){

        return _buildProductList(model.displayedProducts);
      },
    );
  }

  Widget _buildProductList(List<Product> products){

    Widget productCards;

    if(products.length > 0){
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int position) => ProductCard(products[position], position),
        itemCount: products.length,
      );
    }
    else{
      productCards = Container();
    }
    return productCards;
  }
}
