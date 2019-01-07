import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/models/product.dart';
import 'package:flutter_training/models/user.dart';

mixin ConnectedProductsModel on Model{

  List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;

  void addProduct(String title, String description, double price, String image){

    final Product newProduct = Product(
      title: title,
      description: description,
      price: price,
      image: image,
      userEmail: _authenticatedUser.email,
      userId: _authenticatedUser.id
    );
    _products.add(newProduct);
    notifyListeners();
  }
}

mixin ProductsModel on ConnectedProductsModel{

  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if(_showFavorites){
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductPosition{
    return _selectedProductIndex;
  }

  bool get displayFavoritesOnly{
    return _showFavorites;
  }

  Product get selectedProduct{
    if(selectedProductPosition == null){
      return null;
    }
    return _products[selectedProductPosition];
  }

  void updateProduct(String title, String description, double price, String image){

    final Product updatedProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);

    _products[selectedProductPosition] = updatedProduct;

    notifyListeners();
  }

  void deleteProduct(){
    _products.removeAt(selectedProductPosition);
    notifyListeners();
  }

  void toggleProductFavoriteStatus(){
    final bool isCurrentlyFavorite = _products[selectedProductPosition].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);

    _products[_selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(int position){
    _selectedProductIndex = position;
    notifyListeners();
  }

  void toggleDisplayMode(){
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel{

  void login(String email, String password){
    _authenticatedUser = User(id: "dsaddsa", email: email, password: password);
  }
}