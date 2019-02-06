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
//import 'package:map_view/map_view.dart';
import 'shared/adaptive_theme.dart';
import 'helpers/custom_route.dart';

main(){
//  debugPaintSizeEnabled = true;
//  debugPaintBaselinesEnabled = true;
//  debugPaintPointersEnabled = true;
//  MapView.setApiKey('AIzaSyCOtid3XsnFaN3hGD7sQytFACLjiNAE5bo');
  runApp(MainApplication());
}

class MainApplication extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MainApplicationState();
  }
}

class _MainApplicationState extends State<MainApplication>{

  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated){
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    print('building main page');

    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        theme: getAdaptiveThemeData(context),
//      home: AuthPage(),
        routes: {

          "/": (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),

          "/admin": (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
//          "/main": (BuildContext context) => ProductsPage(_model)
        },
        onGenerateRoute: (RouteSettings settings){

          if(!_isAuthenticated){
            return CustomRoute<bool>(
                builder: (BuildContext context) => AuthPage()
            );
          }

          final List<String> pathElements = settings.name.split("/");

          if(pathElements[0] != ""){
            return null;
          }
          if(pathElements[1] == "product"){

            final String productId = pathElements[2];
            final Product product = _model.allProducts.firstWhere((Product product){
              return product.id == productId;
            });

            return CustomRoute<bool>(
                builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductPage(product)
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings){
          return CustomRoute(
              builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model)
          );
        },
      ),
    );
  }

}
