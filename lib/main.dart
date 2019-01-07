import 'package:flutter/material.dart';
import 'package:flutter_training/pages/auth.dart';
import 'package:flutter_training/pages/products_admin.dart';
import 'package:flutter_training/pages/products.dart';
import 'package:flutter_training/pages/product.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter_training/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/scoped_models/products.dart';

main(){
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled = true;
//  debugPaintPointersEnabled = true;
  runApp(MainApplication());
}

class MainApplication extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MainApplicationState();
  }
}

class _MainApplicationState extends State<MainApplication>{

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.red
        ),
//      home: AuthPage(),
        routes: {
          "/admin": (BuildContext context) => ProductsAdminPage(),
          "/": (BuildContext context) => AuthPage(),
          "/main": (BuildContext context) => ProductsPage()
        },
        onGenerateRoute: (RouteSettings settings){
          final List<String> pathElements = settings.name.split("/");
          if(pathElements[0] != ""){
            return null;
          }
          if(pathElements[1] == "product"){
            final int position = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(position)
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings){
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage()
          );
        },
      ),
    );
  }

}
