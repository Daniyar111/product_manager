import 'package:flutter/material.dart';
import 'package:flutter_training/pages/product_edit.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/scoped_models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {

  Widget _buildEditButton(BuildContext context, int position, MainModel model){
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return ListView.builder(
          itemBuilder: (BuildContext context, int position){
            return Dismissible(
              key: Key(model.allProducts[position].title),
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
                        backgroundImage: AssetImage(model.allProducts[position].image),
                      ),
                      title: Text(model.allProducts[position].title),
                      subtitle: Text("\$${model.allProducts[position].price.toString()}"),
                      trailing: _buildEditButton(context, position, model)
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
