import 'package:bloc_hive_caching_data/core/dependency_injection/di.dart';
import 'package:bloc_hive_caching_data/core/helper/connection_helper.dart';
import 'package:bloc_hive_caching_data/core/helper/log_helper.dart';
import 'package:bloc_hive_caching_data/core/resources/data_state.dart';
import 'package:bloc_hive_caching_data/features/home/data/data_source/local/home_db_provider.dart';
import 'package:bloc_hive_caching_data/features/home/data/data_source/remote/home_api_provider.dart';
import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  final HomeApiProvider _apiProvider;
  final HomeDbProvider _dbProvider;

  HomeRepository(this._apiProvider, this._dbProvider);

  // Get Products for Home
  Future<DataState<dynamic>> fetchProducts() async {
    // Firstly, check internet connection
    final bool isConnected = await di<InternetConnectionHelper>()
        .checkInternetConnection();

    // is DataBase Empty or Not
    final bool isDataBaseEmpty = await _dbProvider.isProductsDataAvailable();

    if (isConnected) {
      // try this block
      try {
        final Response response = await _apiProvider.callHomeProductsEndPoint();

        logger.d('Fetch [Products] from Server and cache it in the local DB');

        // Success -Connection is OKAY!!
        if (response.statusCode == 200 &&
            response.data['success'] == true &&
            (response.data['products'] as List).isNotEmpty) {
          ProductsModel productsModel = ProductsModel.fromJson(response.data);
          // Cache Data in Local DB
          _dbProvider.insertProducts(object: productsModel);

          final ProductsModel? cachedProduct = await _dbProvider.getProducts();

          return DataSuccess(cachedProduct);
        }
        // Failed(Unknown Error) - Connection is OKAY!!
        else {
          // We have some cached data in DB
          if (!isDataBaseEmpty) {
            logger.d('Fetch [Products] from Local DB as fallback');
            final ProductsModel? localSourceResponse = await _dbProvider
                .getProducts();
            return DataSuccess(localSourceResponse);
          }

          // There is no data cached!
          // Failed
          return DataFailed('Unknown error happened!');
        }
        // if any error happens
      } catch (e) {
        // We have some cached data in DB
        if (!isDataBaseEmpty) {
          logger.d('Load [Products] from Local DB');
          final ProductsModel? localSourceResponse = await _dbProvider
              .getProducts();
          return DataSuccess(localSourceResponse);
        }
        // Error
        else {
          return DataFailed("Unexpected error happened");
        }
      }
    }
    // User Internet Connection is not Safe - No Internet Connection
    else {
      // We have some cached data in DB
      if (!isDataBaseEmpty) {
        logger.d('Load [Products] from Local DB as fallback');
        final ProductsModel? localSourceResponse = await _dbProvider
            .getProducts();
        return DataSuccess(localSourceResponse);
      }
      // No Internet Connection & No Cached Data
      else {
        return DataFailed("No Internet Connection");
      }
    }
  }
}
