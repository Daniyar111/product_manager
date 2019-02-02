import 'package:flutter/material.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/pages/auth.dart';
import 'package:flutter_training/pages/products_admin.dart';
import 'package:flutter_training/pages/products.dart';
import 'package:flutter_training/pages/product.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_training/scoped_models/main.dart';

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

    final MainModel model = MainModel();

    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.red
        ),
//      home: AuthPage(),
        routes: {
          "/admin": (BuildContext context) => ProductsAdminPage(model),
          "/": (BuildContext context) => AuthPage(),
          "/main": (BuildContext context) => ProductsPage(model)
        },
        onGenerateRoute: (RouteSettings settings){
          final List<String> pathElements = settings.name.split("/");

          if(pathElements[0] != ""){
            return null;
          }
          if(pathElements[1] == "product"){

            final String productId = pathElements[2];
            final Product product = model.allProducts.firstWhere((Product product){
              return product.id == productId;
            });

            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product)
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings){
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model)
          );
        },
      ),
    );
  }

}
