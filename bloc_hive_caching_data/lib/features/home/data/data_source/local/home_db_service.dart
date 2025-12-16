import 'package:bloc_hive_caching_data/config/constants/db_keys.dart';
import 'package:bloc_hive_caching_data/core/helper/log_helper.dart';
import 'package:bloc_hive_caching_data/core/repos/interface_repos.dart';
import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';
import 'package:hive/hive.dart';

class HomeDataBaseService implements InterfaceRepository<ProductsModel> {
  // Box Key
  static const String _key = DbKeys.dbProducts;

  // Product Box
  late final Box<ProductsModel> _productBox;

  // init DB
  Future<void> initDataBase() async {
    try {
      Hive.registerAdapter(ProductsModelAdapter());
      Hive.registerAdapter(ProductsAdapter());
      _productBox = await Hive.openBox(_key);
      logger.d('Success on initializing database For *ProductsModel*');
    } catch (e) {
      // Handle initialization errors
      logger.e('Error on initializing database For *ProductsModel* : $e');
    }
  }

  @override
  Future<ProductsModel?> getAll() async {
    try {
      if (_productBox.isOpen && _productBox.isNotEmpty) {
        return _productBox.get(_key);
      } else {
        return null;
      }
    } catch (e) {
      // Handle read errors
      logger.e('Error on getting All ProductsModel from DB : $e');
    }
  }

  @override
  Future<void> insertItem({required ProductsModel object}) async {
    try {
      await _productBox.put(_key, object);
    } catch (e) {
      // Handle insertion errors
      logger.e('Error on inserting ProductsModel to DB : $e');
    }
  }

  @override
  Future<bool> isDataAvailable() async {
    try {
      return _productBox.isEmpty; // true or false
    } catch (e) {
      // Handle error checking box emptiness
      logger.e('Error checking if box is empty: $e');
      return true; // Return true assuming it's empty on error
    }
  }
}
