import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';

abstract class DataState<T> {
  final T? data;
  final String? error;

  const DataState(this.data, this.error);
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(ProductsModel? cachedProduct, {T? data})
    : super(data, null);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(String error) : super(null, error);
}
