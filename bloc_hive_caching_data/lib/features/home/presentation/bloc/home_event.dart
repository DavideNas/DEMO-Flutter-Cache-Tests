part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  // Classes can only extend other classes.
  // Try specifying a different superclass, or removing the extends clause
  const HomeEvent();

  @override
  List<Object> get props => [];
}

// For Loading Products
class HomeCallProductsEvent extends HomeEvent {
  const HomeCallProductsEvent();

  @override
  List<Object> get props => [];
}
