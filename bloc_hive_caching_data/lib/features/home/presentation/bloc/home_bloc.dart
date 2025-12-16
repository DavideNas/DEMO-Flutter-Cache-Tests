import 'package:bloc/bloc.dart';
import 'package:bloc_hive_caching_data/core/resources/data_state.dart';
import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';
import 'package:bloc_hive_caching_data/features/home/presentation/bloc/home_status.dart';
import 'package:bloc_hive_caching_data/features/home/repository/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc(this._homeRepository)
    : super(HomeState(homeProductsStatus: HomeProductsStatusInit())) {
    // Home Event Handler
    // on Call Home Products Data Event
    on<HomeCallProductsEvent>(_onHomeCallProductsEvent);

    //Other Home Events Handler...
  }

  // on Call Home Products Data Event
  Future<void> _onHomeCallProductsEvent(
    HomeCallProductsEvent event,
    Emitter<HomeState> emit,
  ) async {
    // First lets make state to loading
    emit(state.copyWith(homeProductsStatus: HomeProductsStatusLoading()));

    // get data DataSuccess or DataFailed from Repository
    final DataState dataState = await _homeRepository.fetchProducts();

    // Success on Fetching Data
    if (dataState is DataSuccess) {
      // if data success, lets emit completed state with data
      emit(
        state.copyWith(
          homeProductsStatus: HomeProductsStatusCompleted(
            dataState.data as ProductsModel,
          ),
        ),
      );
    }
    // Failed To Fetch Data
    else if (dataState is DataFailed) {
      // if data failed, lets emit error state with message
      emit(
        state.copyWith(
          homeProductsStatus: HomeProductsStatusError(
            message: dataState.error as String,
          ),
        ),
      );
    }
  }
}
