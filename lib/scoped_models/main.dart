import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_training/scoped_models/connected_product.dart';

class MainModel extends Model with ConnectedProductsModel, UserModel, ProductsModel{

}