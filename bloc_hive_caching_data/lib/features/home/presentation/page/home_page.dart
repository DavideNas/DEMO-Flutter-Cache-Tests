import 'package:bloc_hive_caching_data/core/dependency_injection/di_ex.dart';
import 'package:bloc_hive_caching_data/core/utils/custom_loading_widget.dart';
import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';
import 'package:bloc_hive_caching_data/features/home/presentation/bloc/home_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text('Caching Data With Bloc & Hive'),
            Text(
              '@Demo with BrickpointGames',
              style: theme.textTheme.labelMedium!.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: BlocConsumer<HomeBloc, HomeState>(
          // builder
          builder: (BuildContext context, HomeState state) {
            // init State Status
            if (state.homeProductsStatus is HomeProductsStatusInit) {
              return Container();
            }
            // Loading State Status
            if (state.homeProductsStatus is HomeProductsStatusLoading) {
              return CustomLoading.show(context);
            }

            // Error State Status
            if (state.homeProductsStatus is HomeProductsStatusError) {
              final HomeProductsStatusError emPost =
                  state.homeProductsStatus as HomeProductsStatusError;

              final String errorMsg = emPost.message;

              return Center(
                child: Text(
                  errorMsg,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium,
                ),
              );
            }

            // Completed State Status
            if (state.homeProductsStatus is HomeProductsStatusCompleted) {
              final HomeProductsStatusCompleted cmProducts =
                  state.homeProductsStatus as HomeProductsStatusCompleted;

              final ProductsModel productsModel = cmProducts.products;

              return Center(
                child: Text(
                  productsModel.message.toString(),
                  style: theme.textTheme.labelMedium,
                ),
              );
            }

            return Container();
          },
          listener: (BuildContext context, HomeState state) {},
        ),
      ),
    );
  }
}
