import 'dart:async';
import 'dart:convert';

import 'package:flutter_training/models/auth.dart';
import 'package:flutter_training/models/location_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';


mixin ConnectedProductsModel on Model{

  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;

  final String apiKey = 'AIzaSyC_elvWmIDvqrq2CdEdHgSnkwApndf8-SE';
  final String imageUrl = "https://p2.trrsf.com/image/fget/cf/460/0/images.terra.com/2018/05/11/chocolate.jpg";
  final String baseUrl = "https://productmanager-edceb.firebaseio.com/";

  final String authUrl = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/";
//  final String mapApiKey = 'AIzaSyCOtid3XsnFaN3hGD7sQytFACLjiNAE5bo';
}

mixin ProductsModel on ConnectedProductsModel{

  bool _showFavorites = false;



  bool get isLoading{
    return _isLoading;
  }



  List<Product> get allProducts {
    return List.from(_products);
  }




  List<Product> get displayedProducts {

    if(_showFavorites){
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }



  String get selectedProductId{
    return _selectedProductId;
  }



  bool get displayFavoritesOnly{
    return _showFavorites;
  }



  Product get selectedProduct{

    if(selectedProductId == null){
      return null;
    }
    return _products.firstWhere((Product product){
      return product.id == _selectedProductId;
    });
  }


// if indexWhere didn't find, it equals to -1, not null
  int get selectedProductPosition{
    return _products.indexWhere((Product product){
      return product.id == _selectedProductId;
    });
  }



  Future<bool> addProduct(String title, String description, double price, String image, LocationData locationData) async {

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
      "title": title,
      "description": description,
      "price": price,
      "image": imageUrl,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'loc_lat': locationData.latitude,
      'loc_lng': locationData.longitude,
      'loc_address': locationData.address
    };


    return http.post(
        "${baseUrl}products.json?auth=${_authenticatedUser.token}",
        body: json.encode(productData)
    ).then((http.Response response){

      if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      print("responseData $responseData");

      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        price: price,
        image: image,
        location: locationData,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
      );
      _products.add(newProduct);

      _isLoading = false;
      notifyListeners();

      return true;
    }).catchError((error){
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }






// get
  Future<Null> fetchProducts({onlyForUser = false}) {

    _isLoading = true;
    notifyListeners();

    return http.get("${baseUrl}products.json?auth=${_authenticatedUser.token}")
      .then<Null>((http.Response response){

        final Map<String, dynamic> productListData = json.decode(response.body);
        print(productListData);

        final List<Product> fetchedProductList = [];

        if(productListData == null){
          _isLoading = false;
          notifyListeners();
          return;
        }

        productListData.forEach((String productId, dynamic productData) {

          final Product product = Product(
            id: productId,
            title: productData["title"],
            description: productData["description"],
            image: productData["image"],
            price: productData["price"],
            location: LocationData(
              address: productData['loc_address'],
              latitude: productData['loc_lat'],
              longitude: productData['loc_lng']),
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavorite: productData['wishlistUsers'] == null ? false : (productData['wishlistUsers'] as Map<String, dynamic>).containsKey(_authenticatedUser.id)
          );

          fetchedProductList.add(product);
        });

        _products = onlyForUser
            ? fetchedProductList.where((Product product){
                return product.userId == _authenticatedUser.id;
              }).toList()
            : fetchedProductList;

        _isLoading = false;
        notifyListeners();
        _selectedProductId = null;

    }).catchError((error){
      _isLoading = false;
      notifyListeners();
      return;
    });
  }





  Future<bool> updateProduct(String title, String description, double price, String image, LocationData location) async{

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updatedData = {
      "title": title,
      "description": description,
      "price": price,
      "image": imageUrl,
      'loc_lat': location.latitude,
      'loc_lng': location.longitude,
      'loc_address': location.address,
      "userEmail": selectedProduct.userEmail,
      "userId": selectedProduct.userId,
    };

    return http.put(
      "${baseUrl}products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}",
      body: json.encode(updatedData)
    ).then((http.Response response){

      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          location: location,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId
      );


      _products[selectedProductPosition] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error){
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }




  Future<bool> deleteProduct() async{

    _isLoading = true;

    final String deletedProductId = selectedProduct.id;


    _products.removeAt(selectedProductPosition);
    _selectedProductId = null;
    notifyListeners();

    return http.delete(
        "${baseUrl}products/$deletedProductId.json?auth=${_authenticatedUser.token}"
      ).then((http.Response response){

        _isLoading = false;
        notifyListeners();

        return true;
      }).catchError((error){
        _isLoading = false;
        notifyListeners();
        return false;
    });
  }



  void toggleProductFavoriteStatus() async{

    final bool isCurrentlyFavorite = _products[selectedProductPosition].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        location: selectedProduct.location,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus
    );

    _products[selectedProductPosition] = updatedProduct;
    notifyListeners();

    http.Response response;

    if(newFavoriteStatus){
      response = await http.put(
        "${baseUrl}products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}",
        body: json.encode(true)
      );


    }
    else{
      response = await http.delete(
        "${baseUrl}products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}"
      );
    }

    if(response.statusCode != 200 && response.statusCode != 201){
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          location: selectedProduct.location,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteStatus
      );

      _products[selectedProductPosition] = updatedProduct;
      notifyListeners();
    }



  }



  void selectProduct(String id){
    _selectedProductId = id;
    if(id != null){
      notifyListeners();
    }
  }


  void toggleDisplayMode(){
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}



mixin UserModel on ConnectedProductsModel{

  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }


  Future<Map<String, dynamic>> authenticate(String email, String password, [AuthMode mode = AuthMode.Login]) async {

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    if(mode == AuthMode.Login){
      response = await http.post(
        "${authUrl}verifyPassword?key=$apiKey",
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode(authData)
      );
    }
    else{
      response = await http.post(
        "${authUrl}signupNewUser?key=$apiKey",
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode(authData)
      );
    }


    final Map<String, dynamic> responseData = json.decode(response.body);
    print("response data $responseData");

    bool hasError = true;
    String message = 'Something went wrong.';

    if(responseData.containsKey('idToken')) {
      hasError = false;
      message = "Authentication succeeded!";

      _authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken']
      );

      setAuthTimeout(int.parse(responseData['expiresIn']));
      print("DateTime expiresIn ${responseData['expiresIn']}");

      _userSubject.add(true);

      final DateTime now = DateTime.now();
      final DateTime expiryTime = now.add(Duration(
        seconds: int.parse(responseData['expiresIn'])
      ));

      print("DateTime now ${now.toString()}");
      print("DateTime expiryTime toString ${expiryTime.toString()}");
      print("DateTime expiryTime toISO8601String ${expiryTime.toIso8601String()}");

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString('token', responseData['idToken']);
      sharedPreferences.setString('userEmail', email);
      sharedPreferences.setString('userId', responseData['localId']);
      sharedPreferences.setString('expiryTime', expiryTime.toIso8601String());
    }
    else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND'){
      message = 'Email not found.';
    }
    else if(responseData['error']['message'] == 'INVALID_PASSWORD'){
      message = 'Password incorrect.';
    }
    else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      message = 'This email already exists.';
    }

    _isLoading = false;
    notifyListeners();

    return {'success': !hasError, 'message': message};

  }



  void setAuthTimeout(int time){
    _authTimer = Timer(Duration(seconds: time), logout);
  }



  void logout() async {

    print('Logout');

    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
    sharedPreferences.remove('userEmail');
    sharedPreferences.remove('userId');
    notifyListeners();
  }




  void autoAuthenticate() async {

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString('token');
    final String expiryTimeString = sharedPreferences.getString('expiryTime');

    if(token != null){
      final DateTime now = DateTime.now();
      final parsedExpiredTime = DateTime.parse(expiryTimeString);
      print("expiryTimeString $expiryTimeString");
      print("expiryTimeString parsed DateTime $parsedExpiredTime");

      if(parsedExpiredTime.isBefore(now)){
        _authenticatedUser = null;
        notifyListeners();
        return;
      }

      final String email = sharedPreferences.getString('userEmail');
      final String id = sharedPreferences.getString('userId');

      final int tokenLifeSpan = parsedExpiredTime.difference(now).inSeconds;
      print("tokenLifeSpan $tokenLifeSpan");

      _authenticatedUser = User(id: id, email: email, token: token);
      setAuthTimeout(tokenLifeSpan);

      _userSubject.add(true);

      notifyListeners();
    }
  }


}