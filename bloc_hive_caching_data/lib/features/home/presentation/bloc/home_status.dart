import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeProductsStatus {}

class HomeProductsStatusInit extends HomeProductsStatus {}

class HomeProductsStatusLoading extends HomeProductsStatus {}

class HomeProductsStatusError extends HomeProductsStatus {
  final String message;
  HomeProductsStatusError({required this.message});
}

class HomeProductsStatusCompleted extends HomeProductsStatus {
  final ProductsModel products;
  HomeProductsStatusCompleted(this.products);
}
