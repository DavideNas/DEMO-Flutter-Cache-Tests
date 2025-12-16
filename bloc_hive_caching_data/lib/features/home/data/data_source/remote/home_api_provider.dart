import 'package:bloc_hive_caching_data/core/helper/log_helper.dart';
import 'package:bloc_hive_caching_data/config/constants/api_constants.dart';
import 'package:dio/dio.dart';

class HomeApiProvider {
  final Dio dio;
  HomeApiProvider(this.dio);

  // Call Home Page Products Data
  dynamic callHomeProductsEndPoint() async {
    final requestUrl = EnvironmentVariables.getProducts;

    final response = await dio
        .request(requestUrl, options: Options(method: 'GET'))
        .onError((DioException error, stackTrace) {
          logger.e(error.toString());
          throw error;
        });

    // response
    return response;
  }
}
