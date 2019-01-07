import 'package:flutter/material.dart';
import 'package:flutter_training/widgets/products/price_tag.dart';
import 'package:flutter_training/widgets/products/address_tag.dart';
import 'package:flutter_training/widgets/ui_elements/title_default.dart';
import 'package:flutter_training/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/scoped_models/products.dart';

class ProductCard extends StatelessWidget {

  final Product product;
  final int productPosition;

  ProductCard(this.product, this.productPosition);

  Widget _buildTitlePriceRow(){
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(width: 8),
            PriceTag(product.price.toString())
          ],
        )
    );
  }

  Widget _buildActionButton(BuildContext context){
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.info),
            color: Colors.blue,
            onPressed: () => Navigator.pushNamed<bool>(context, "/product/$productPosition")
        ),
        ScopedModelDescendant<ProductsModel>(
          builder: (BuildContext context, Widget child, ProductsModel model){
            return IconButton(
                icon: Icon(model.products[productPosition].isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectProduct(productPosition);
                  model.toggleProductFavoriteStatus();
                }
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
          Image.asset(product.image),
          _buildTitlePriceRow(),
          AddressTag("Union Square, San Francisco"),
          _buildActionButton(context)
        ])
    );
  }
}
