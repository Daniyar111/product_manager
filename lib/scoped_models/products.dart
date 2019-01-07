import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/models/product.dart';

class ProductsModel extends Model{

  List<Product> _products = [];
  int _selectedProductPosition;
  bool _showFavorites = false;

  List<Product> get products {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if(_showFavorites){
      return List.from(_products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(_products);
  }

  int get selectedProductPosition{
    return _selectedProductPosition;
  }

  bool get displayFavoritesOnly{
    return _showFavorites;
  }

  Product get selectedProduct{
    if(_selectedProductPosition == null){
      return null;
    }
    return _products[_selectedProductPosition];
  }

  void addProduct(Product product){
    _products.add(product);
    _selectedProductPosition = null;
    notifyListeners();
  }

  void updateProduct(Product product){
    _products[_selectedProductPosition] = product;
    _selectedProductPosition = null;
    notifyListeners();
  }

  void deleteProduct(){
    _products.removeAt(_selectedProductPosition);
    _selectedProductPosition = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus(){
    final bool isCurrentlyFavorite = _products[_selectedProductPosition].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(title: selectedProduct.title, description: selectedProduct.description, price: selectedProduct.price, image: selectedProduct.image, isFavorite: newFavoriteStatus);
    updateProduct(updatedProduct);
    notifyListeners();
  }

  void selectProduct(int position){
    _selectedProductPosition = position;
    notifyListeners();
  }

  void toggleDisplayMode(){
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}