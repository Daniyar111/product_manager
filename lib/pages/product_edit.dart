import 'package:flutter/material.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/widgets/form_inputs/location.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/scoped_models/main.dart';


class ProductEditPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage>{

  final Map<String, dynamic> _formData = {
    "title": null,
    "description": null,
    "price": null,
    "image": "assets/killer.jpg"
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product){

    return TextFormField(
      decoration: InputDecoration(
          labelText: "Product Title"
      ),
      initialValue: product == null ? "" : product.title,
      validator: (String value){

        if(value.isEmpty || value.length < 5){
          return "Title is required and should be 5+ characters long";
        }
      },

      onSaved: (String value){
        _formData["title"] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Product product){

    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
          labelText: "Product Description"
      ),
      initialValue: product == null ? "" : product.description,
      validator: (String value){

        if(value.isEmpty || value.length < 10){
          return "Description is required and should be 10+ characters long";
        }
      },

      onSaved: (String value){
        _formData["description"] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product product){

    return TextFormField(
      decoration: InputDecoration(
          labelText: "Product Price"
      ),
      keyboardType: TextInputType.number,
      initialValue: product == null ? "" : product.price.toString(),
      validator: (String value){

        if(value.isEmpty || !RegExp(r"^(?:[1-9]\d*|0)?(?:\.\d+)?$").hasMatch(value)){
          return "Price is required and should be a number";
        }
      },

      onSaved: (String value){
        _formData["price"] = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton(){

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){

        return model.isLoading
          ? Center(child: CircularProgressIndicator(),)
          : RaisedButton(
            child: Text("SAVE"),
            textColor: Colors.white,
            onPressed: () => _onCreatePressed(model.addProduct, model.updateProduct, model.selectProduct, model.selectedProductPosition),

        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product){

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },

      child: Container(
        width: targetWidth,
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[

              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 10,),
              _buildSubmitButton()
//                GestureDetector(
//                  onTap: _onCreatePressed,
//                  child: Container(
//                    child: Text("SAVE"),
//                    color: Colors.green,
//                    padding: EdgeInsets.all(5),
//                  ),
//                )
            ],
          ),
        )
      ),
    );
  }

  void _showWarningDialog(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            title: Text("Something went wrong"),
            content: Text("Please try again!"),
            actions: <Widget>[

              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  void _onCreatePressed(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductPosition]){

    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();

    if(selectedProductPosition == -1){
      addProduct (
        _formData["title"],
        _formData["description"],
        _formData["price"],
        _formData["image"]
      ).then((bool success){
        if(success){
          Navigator.pushReplacementNamed(context, "/main").then((_) => setSelectedProduct(null));
        }
        else{
          _showWarningDialog(context);
        }
      });
    }
    else{
      updateProduct(
        _formData["title"],
        _formData["description"],
        _formData["price"],
        _formData["image"]
      ).then((_){
        Navigator.pushReplacementNamed(context, "/main").then((_) => setSelectedProduct(null));
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel product){

        final Widget pageContent = _buildPageContent(context, product.selectedProduct);

        return product.selectedProductPosition == -1
          ? pageContent
          : Scaffold(
            appBar: AppBar(
              title: Text("Edit Product"),
            ),
            body: pageContent,
          );
      },
    );
  }
}



































//class ProductEditPage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _ProductEditPageState();
//  }
//}
//
//class _ProductEditPageState extends State<ProductEditPage> {
//  final Map<String, dynamic> _formData = {
//    "title": null,
//    "description": null,
//    "price": null,
//    "image": "assets/killer.jpg",
//    "location": null
//  };
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  final RegExp _priceRegExp = RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$');
//  final TextEditingController _titleTextController = TextEditingController();
//
//  Widget _buildTitleTextField(Product product) {
//
//    if (product == null && _titleTextController.text.trim() == '') {
//
//      // no product and no values entered by user
//      _titleTextController.text = '';
//    }
//    else if (product != null && _titleTextController.text.trim() == '') {
//
//      // there is a product and the user didn't entered something
//      _titleTextController.text = product.title;
//    }
//    else if (product != null && _titleTextController.text.trim() != '') {
//
//      // there is a product and the user entered something
//      _titleTextController.text = _titleTextController.text;
//    }
//    else if (product == null && _titleTextController.text.trim() != '') {
//
//      // no product and the user added something
//      _titleTextController.text = _titleTextController.text;
//    }
//    else {
//      _titleTextController.text = '';
//    }
//
//    return TextFormField(
//      controller: _titleTextController,
//      decoration: InputDecoration(labelText: "Product Title"),
////      initialValue: product == null ? "" : product.title,
//      validator: (String value) {
//        if (value.isEmpty || value.length < 3) {
//          return "Title is required and should be 3+ characters long";
//        }
//      },
//      onSaved: (String value) {
//        _formData["title"] = value;
//      },
//    );
//  }
//
//  Widget _buildDescriptionTextField(Product product) {
//
//    return TextFormField(
//      maxLines: 4,
//      decoration: InputDecoration(labelText: "Product Description"),
//      initialValue: product == null ? "" : product.description,
//      validator: (String value) {
//        if (value.isEmpty || value.length < 10) {
//          return "Description is required and should be 10+ characters long";
//        }
//      },
//      onSaved: (String value) {
//        _formData["description"] = value;
//      },
//    );
//  }
//
//  Widget _buildPriceTextField(Product product) {
//
//    return TextFormField(
//      decoration: InputDecoration(labelText: "Product Price"),
//      keyboardType: TextInputType.number,
//      initialValue: product == null ? "" : product.price.toString(),
//      validator: (String value) {
//        if (value.isEmpty || !_priceRegExp.hasMatch(value)) {
//          return "Price is required and should be a number";
//        }
//      },
//      onSaved: (String value) {
//        _formData["price"] = double.parse(value);
//      },
//    );
//  }
//
//  Widget _buildSubmitButton(MainModel model) {
//    return model.isLoading
//        ? Center(child: CircularProgressIndicator(value: null,))
//        : RaisedButton(
//      child: Text("SAVE"),
//      textColor: Colors.white,
//      onPressed: () => _onCreatePressed(
//          model.addProduct,
//          model.updateProduct,
//          model.selectProduct,
//          model.selectedProductPosition),
//    );
//  }
//
//  void _setLocation(LocationData locationData){
//    _formData["location"] = locationData;
//  }
//
//  Widget _buildPageContent(BuildContext context, Product selectedProduct, MainModel model) {
//    final double deviceWidth = MediaQuery.of(context).size.width;
//    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;
//    final double targetPadding = deviceWidth - targetWidth;
//
//    return WillPopScope(
//      onWillPop: (){
//        model.selectProduct(null);
//        return Future.value(true);
//      },
//      child: GestureDetector(
//        onTap: () {
//          FocusScope.of(context).requestFocus(FocusNode());
//        },
//        child: Container(
//            margin: EdgeInsets.all(10),
//            child: Form(
//              key: _formKey,
//              child: ListView(
//                padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
//                children: <Widget>[
//                  _buildTitleTextField(selectedProduct),
//                  _buildDescriptionTextField(selectedProduct),
//                  _buildPriceTextField(selectedProduct),
//                  SizedBox(height: 10,),
//                  LocationInput(selectedProduct, _setLocation),
//                  SizedBox(height: 10,),
//                  _buildSubmitButton(model),
//                ],
//              ),
//            )),
//      ),
//    );
//  }
//
//  void _onCreatePressed(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductPosition]) {
//
//    if (!_formKey.currentState.validate()) {
//      return;
//    }
//    _formKey.currentState.save();
//    if (selectedProductPosition == -1) {
//      addProduct(
//        _titleTextController.text,
//        _formData["description"],
//        _formData["price"],
//        _formData["image"],
//        _formData["location"]
//      ).then((bool success){
//        if(success){
//          Navigator.pushReplacementNamed(context, "/main")
//              .then((_) => setSelectedProduct(null));
//        }
//        else{
//          showDialog(
//            context: context,
//            builder: (BuildContext context) {
//
//              return AlertDialog(
//                title: Text('Something went wrong',),
//                content: Text('Please try again'),
//                actions: <Widget>[
//                  FlatButton(
//                    onPressed: () => Navigator.of(context).pop(),
//                    child: Text('OK'),
//                  ),
//                ]
//              );
//            }
//          );
//        }
//      });
//    } else {
//      updateProduct(
//        _titleTextController.text,
//        _formData["description"],
//        _formData["price"],
//        _formData["image"],
//        _formData["location"]
//      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
//        .then((_) => setSelectedProduct(null)));
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ScopedModelDescendant<MainModel>(
//      builder: (BuildContext context, Widget child, MainModel model) {
//        final Widget pageContent = _buildPageContent(context, model.selectedProduct, model);
//
//        return model.selectedProductPosition == -1
//            ? pageContent
//            : Scaffold(
//                appBar: AppBar(
//                  title: Text("Edit Product"),
//                ),
//                body: pageContent,
//              );
//      },
//    );
//  }
//}
