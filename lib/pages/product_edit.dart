import 'package:flutter/material.dart';
import 'package:flutter_training/models/product.dart';
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
      builder: (BuildContext context, Widget child, MainModel product){
        return RaisedButton(
          child: Text("SAVE"),
          textColor: Colors.white,
          onPressed: () => _onCreatePressed(product.addProduct, product.updateProduct, product.selectProduct, product.selectedProductPosition),
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
                SizedBox(
                  height: 10,
                ),
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

  void _onCreatePressed(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductPosition]){
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
    if(selectedProductPosition == null){
      addProduct(
          _formData["title"],
          _formData["description"],
          _formData["price"],
          _formData["image"]
      );

    } else {
      updateProduct(
          _formData["title"],
          _formData["description"],
          _formData["price"],
          _formData["image"]
      );
    }

    Navigator.pushReplacementNamed(context, "/main").then((_) => setSelectedProduct(null));
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel product){
        final Widget pageContent = _buildPageContent(context, product.selectedProduct);
        return product.selectedProductPosition == null ? pageContent : Scaffold(
          appBar: AppBar(
            title: Text("Edit Product"),
          ),
          body: pageContent,
        );
      },
    );


  }
}
