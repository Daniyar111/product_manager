import 'package:flutter/material.dart';
import 'package:flutter_training/pages/product_edit.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/scoped_models/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {

  Widget _buildEditButton(BuildContext context, int position, ProductsModel model){
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: (){
        model.selectProduct(position);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return ProductEditPage();
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model){
        return ListView.builder(
          itemBuilder: (BuildContext context, int position){
            return Dismissible(
              key: Key(model.products[position].title),
              background: Container(color: Colors.red,),
//          secondaryBackground: Container(color: Colors.green,),
              onDismissed: (DismissDirection direction){
                if(direction == DismissDirection.endToStart){
                  model.selectProduct(position);
                  model.deleteProduct();
                }
                else if(direction == DismissDirection.startToEnd){
                  print("Swiped start to end");
                }
                else{
                  print("Other swiping");
                }
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(model.products[position].image),
                      ),
                      title: Text(model.products[position].title),
                      subtitle: Text("\$${model.products[position].price.toString()}"),
                      trailing: _buildEditButton(context, position, model)
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
