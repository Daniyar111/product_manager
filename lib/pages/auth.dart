import 'package:flutter/material.dart';
import 'package:flutter_training/models/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/scoped_models/main.dart';



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

  DecorationImage _buildBackgroundImage(){

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

  void _onLoginPressed(Function login){

    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();

    if(!_acceptTerms){
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please, Accept Terms")));
      return;
    }

    login(_formData["email"], _formData["password"]);
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
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                        SizedBox(height: 10),

                        ScopedModelDescendant<MainModel>(
                          builder: (BuildContext context, Widget child, MainModel model){

                            return RaisedButton(
                              child: Text("LOGIN"),
                              textColor: Colors.white,
                              onPressed: () => _onLoginPressed(model.login),
                            );
                          },
                        )
                      ],
                    ),
                  )
                )
              ),
            ),
          )
      ),
    );
  }
}




































//class AuthPage extends StatefulWidget {
//
//  @override
//  State<StatefulWidget> createState() {
//    return _AuthPageState();
//  }
//}
//
//class _AuthPageState extends State<AuthPage>{
//
//  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
////  final TextEditingController _passwordTextController = new TextEditingController();
////  AuthMode _authMode = AuthMode.Login;
//
//  final Map<String, dynamic> _formData = {
//    "email": null,
//    "password": null,
//    'acceptTerms': false
//  };
////  bool _acceptTerms = false;
////  bool _obscureText = true;
////  bool _obscureText2 = true;
//  RegExp _emailRegExp = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
//
//  DecorationImage _buildBackgroundImage(){
//
//    return DecorationImage(
//        fit: BoxFit.cover,
//        alignment: Alignment.center,
//        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
//        image: AssetImage("assets/background_auth.jpg")
//    );
//  }
//
////  Widget _buildPopUpMenuButton() {
////
////    return PopupMenuButton<AuthMode>(
////      onSelected: (AuthMode result){
////        setState(() {
////          _authMode = result;
////        });
////      },
////      itemBuilder: (BuildContext context) => <PopupMenuEntry<AuthMode>>[
////        const PopupMenuItem<AuthMode>(
////          value: AuthMode.Login,
////          child: Text('Login'),
////        ),
////        const PopupMenuItem<AuthMode>(
////          value: AuthMode.Signup,
////          child: Text('Sign Up'),
////        )
////      ],
////    );
////  }
////
////  Widget _buildForm(Widget loginButton) {
////
////    return Form(
////      key: _formKey,
////      child: Column(
////        children: <Widget>[
////          _buildEmailTextField(),
////          SizedBox(height: 19.0,),
////          _buildPasswordTextField(),
////          SizedBox(height: 19.0,),
////
////          _authMode == AuthMode.Signup
////              ? _buildPasswordConfirmTextField()
////              : Container(),
////
////          _buildSwitchAccept(),
////          SizedBox(height: 11.0,),
////          loginButton,
////        ],
////      ),
////    );
////  }
//
//  Widget _buildEmailTextField(){
//
//    return TextFormField(
//      decoration: InputDecoration(
//        labelText: "E-Mail",
//        filled: true,
//        fillColor: Colors.white
//      ),
//      keyboardType: TextInputType.emailAddress,
//      validator: (String value){
//        if(value.isEmpty || !_emailRegExp.hasMatch(value)){
//          return "Type a valid e-mail";
//        }
//      },
//      onSaved: (String value){
//        _formData["email"] = value;
//      },
//    );
//  }
//
//  Widget _buildPasswordTextField(){
//
//    return TextFormField(
////      controller: _passwordTextController,
//      decoration: InputDecoration(
//          labelText: "Password",
//          filled: true,
//          fillColor: Colors.white,
////          suffixIcon: GestureDetector(
////            onTap: () => setState(() => _obscureText = !_obscureText),
////            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
////          ),
//      ),
//      obscureText: true,
//      validator: (String value){
//        if(value.length < 6){
//          return "Password must be at least 6 characters long";
//        }
//      },
//      onSaved: (String value) => _formData["password"] = value,
//    );
//  }
//
////  Widget _buildPasswordConfirmTextField(){
////
////    return TextFormField(
////      controller: _passwordTextController,
////      decoration: InputDecoration(
////        labelText: "Password",
////        filled: true,
////        fillColor: Colors.white,
////        suffixIcon: GestureDetector(
////          onTap: () => setState(() => _obscureText2 = !_obscureText),
////          child: Icon(_obscureText2 ? Icons.visibility : Icons.visibility_off),
////        ),
////      ),
////      obscureText: _obscureText2,
////      keyboardType: TextInputType.text,
////      validator: (String value){
////        if (_passwordTextController.text != value) {
////          return 'Passwords do not match';
////        }
////      },
////      onSaved: (String value) => _formData["password"] = value,
////    );
////  }
//
//  Widget _buildSwitchAccept(){
//
//    return SwitchListTile(
//      value: _formData['acceptTerms'],
//      onChanged: (bool value){
//        setState(() {
//          _formData['acceptTerms'] = value;
//        });
//      },
//      title: Text("Accept Terms"),
//    );
//  }
//
//  void _onAuthPressed(Function login) /*async*/ {
//    if(!_formKey.currentState.validate() || !_formData['acceptTerms']){
//      return;
//    }
//    _formKey.currentState.save();
//
//    login(_formData['email'], _formData['password']);
//    Navigator.pushReplacementNamed(context, '/products');
//
////    Map<String, dynamic> info;
////
////    info = await auth(_formData['email'], _formData['password'], _authMode);
////
////    if(info['success']){
////       Navigator.pushReplacementNamed(context, '/main');
////    }
////    else{
////      showDialog(
////        context: context,
////        builder: (BuildContext context) {
////          return AlertDialog(
////            title: Text('Error'),
////            content: Text(info['message']),
////            actions: <Widget>[
////              FlatButton(
////                child: Text('OK'),
////                onPressed: () => Navigator.of(context).pop(),
////              )
////            ],
////          );
////        }
////      );
////    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    Widget loginButton = SizedBox(height: 48);
//    final targetWidth = MediaQuery.of(context).size.width > 768
//        ? 500
//        : MediaQuery.of(context).size.width * 0.8;
//
////    if (_acceptTerms) {
////      loginButton = ScopedModelDescendant<MainModel>(
////        builder: (BuildContext context, Widget child, MainModel model) {
////
////          return model.isLoading
////              ? CircularProgressIndicator(value: null,)
////              : RaisedButton(
////            textColor: Colors.white,
////            child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
////            onPressed: () => _onAuthPressed(model.auth),
////          );
////        },
////      );
////    }
//
//    return Scaffold(
//      appBar: AppBar(
////        title: Text(_authMode == AuthMode.Login ? 'Login' : 'Sign Up'),
//        title: Text('Login'),
////        actions: <Widget>[
////          _buildPopUpMenuButton()
////        ],
//      ),
//      body: Container(
//        decoration: BoxDecoration(
//          image: _buildBackgroundImage()
//        ),
//        padding: EdgeInsets.all(10),
////        child: GestureDetector(
////          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//        child: Center(
//          child: SingleChildScrollView(
//            child: Container(
//              width: targetWidth,
//              child: Form(
//                key: _for,
//              ),
//            ),
//          ),
//        ),
//        )
////      ),
//    );
//  }
//}
