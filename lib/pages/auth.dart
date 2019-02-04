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
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

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
      controller: _passwordTextController,
      obscureText: true,
      validator: (String value){

        if(value.length < 6){
          return "Password must be at least 6 characters long";
        }
      },

      onSaved: (String value) => _formData["password"] = value,
    );
  }


  Widget _buildPasswordConfirmTextField(){

    return TextFormField(
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          labelText: "Confirm Password",
          filled: true,
          fillColor: Colors.white
      ),
      obscureText: true,
      validator: (String value){

        if(_passwordTextController.text != value){
          return "Passwords do not match.";
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


  void _showWarningDialog(BuildContext context, Map<String, dynamic> info) {

    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            title: Text("An Error Occured!"),
            content: Text(info['message']),
            actions: <Widget>[

              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }


  void _onLoginPressed(Function authenticate) async{

    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();

    if(!_acceptTerms){
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please, Accept Terms")));
      return;
    }

    Map<String, dynamic> successInformation;


      successInformation = await authenticate(_formData["email"], _formData["password"], _authMode);

      if(successInformation['success']){
//        Navigator.pushReplacementNamed(context, "/");
      }
      else{
        _showWarningDialog(context, successInformation);
      }
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
                        SizedBox(height: 10),

                        _authMode == AuthMode.Signup
                            ? _buildPasswordConfirmTextField()
                            : Container(),

                        _buildSwitchAccept(),
                        SizedBox(height: 10),

                        FlatButton(
                          child: Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                          onPressed: (){
                            setState(() {
                              _authMode = _authMode == AuthMode.Login
                                  ? AuthMode.Signup
                                  : AuthMode.Login;
                            });
                          },
                        ),
                        SizedBox(height: 10),

                        ScopedModelDescendant<MainModel>(
                          builder: (BuildContext context, Widget child, MainModel model){

                            return model.isLoading
                                ? CircularProgressIndicator()
                                : RaisedButton(
                                  child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'),
                                  textColor: Colors.white,
                                  onPressed: () => _onLoginPressed(model.authenticate),
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