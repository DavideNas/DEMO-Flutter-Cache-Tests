part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  final HomeProductsStatus homeProductsStatus;

  const HomeState({required this.homeProductsStatus});

  @override
  List<Object?> get props => [homeProductsStatus];

  HomeState copyWith({HomeProductsStatus? homeProductsStatus}) {
    return HomeState(
      homeProductsStatus: homeProductsStatus ?? this.homeProductsStatus,
    );
  }
}
