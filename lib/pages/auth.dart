import 'package:flutter/material.dart';
import 'products.dart';

class AuthPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Map<String, dynamic> _formData = {
    "email": null,
    "password": null
  };
  bool _acceptTerms = false;
  RegExp _emailRegExp = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  _buildBackgroundImage(){
    return DecorationImage(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage("assets/background_auth.jpg")
    );
  }

  Widget _buildEmailTextField(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "E-Mail",
        filled: true,
        fillColor: Colors.white
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value){
        if(value.isEmpty || !_emailRegExp.hasMatch(value)){
          return "Type a valid e-mail";
        }
      },
      onSaved: (String value) => _formData["email"] = value,
    );
  }

  Widget _buildPasswordTextField(){
    return TextFormField(
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: "Password",
          filled: true,
          fillColor: Colors.white
      ),
      obscureText: true,
      validator: (String value){
        if(value.length < 6){
          return "Password must be at least 6 characters long";
        }
      },
      onSaved: (String value) => _formData["password"] = value,
    );
  }

  Widget _buildSwitchAccept(){
    return SwitchListTile(
      value: _acceptTerms,
      onChanged: (bool value){
        setState(() {
          _acceptTerms = value;
        });
      },
      title: Text("Accept Terms"),
    );
  }

  _onLoginPressed(){
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();

    if(!_acceptTerms){
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please, Accept Terms")));
      return;
    }
    Navigator.pushReplacementNamed(context, "/main");
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550 ? 500 : deviceWidth * 0.95;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage()
        ),
        padding: EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(height: 10,),
                    _buildPasswordTextField(),
                    _buildSwitchAccept(),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: Text("LOGIN"),
                      textColor: Colors.white,
                      onPressed: _onLoginPressed,
                    )
                  ],
                ),
              )
            )
          ),
        )
      ),
    );
  }
}
