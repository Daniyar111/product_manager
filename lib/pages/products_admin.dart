import 'package:flutter/material.dart';
import 'package:flutter_training/pages/product_edit.dart';
import 'package:flutter_training/pages/product_list.dart';

class ProductsAdminPage extends StatelessWidget {

  Widget _buildSideDrawer(BuildContext context){
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Products"),
            onTap: (){
              Navigator.pushReplacementNamed(context, "/main");
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text("Manager"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Create Product",
                icon: Icon(Icons.create),
              ),
              Tab(
                text: "My products",
                icon: Icon(Icons.list),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(),
            ProductListPage()
          ],
        )
      ),
    );
  }
}
