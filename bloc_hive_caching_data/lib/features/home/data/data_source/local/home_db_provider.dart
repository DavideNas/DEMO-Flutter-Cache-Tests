import 'package:bloc_hive_caching_data/core/helper/log_helper.dart';
import 'package:bloc_hive_caching_data/features/home/data/data_source/local/home_db_service.dart';
import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';

class HomeDbProvider {
  final HomeDataBaseService _homeDatabaseService;

  HomeDbProvider({required HomeDataBaseService homeDatabaseService})
    : _homeDatabaseService = homeDatabaseService;

  // Read From DB
  Future<ProductsModel?> getProducts() async {
    try {
      logger.i('Products fetched from DB successfully');
      return await _homeDatabaseService.getAll();
    } catch (e) {
      // Log or handle read errors
      logger.e('Error reading from DB: $e');
      return null;
    }
  }

  // Insert To DB
  Future<void> insertProducts({required ProductsModel object}) async {
    try {
      await _homeDatabaseService.insertItem(object: object);
    } catch (e) {
      // Handle insertion errors
      logger.e('Error inserting Products: $e');
    }
  }

  // Is Data Available
  Future<bool> isProductsDataAvailable() async {
    return await _homeDatabaseService.isDataAvailable();
  }
}
