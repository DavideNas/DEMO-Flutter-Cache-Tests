import 'package:bloc_hive_caching_data/core/dependency_injection/di.dart';
import 'package:bloc_hive_caching_data/core/dependency_injection/di_ex.dart';
import 'package:bloc_hive_caching_data/core/pages/error_page.dart';
import 'package:bloc_hive_caching_data/core/utils/custom_alert.dart';
import 'package:bloc_hive_caching_data/core/utils/custom_loading_widget.dart';
import 'package:bloc_hive_caching_data/features/home/data/model/product_model.dart';
import 'package:bloc_hive_caching_data/features/home/presentation/bloc/home_status.dart';
import 'package:bloc_hive_caching_data/features/home/presentation/widget/bnb.dart';
import 'package:bloc_hive_caching_data/features/home/presentation/widget/home_single_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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
      bottomNavigationBar: BNB(),
      body: SizedBox(
        height: height,
        width: width,
        child: BlocConsumer<HomeBloc, HomeState>(
          // build when
          buildWhen: (previous, current) {
            return previous.homeProductsStatus != current.homeProductsStatus;
          },

          // listen when
          listenWhen: (previous, current) {
            return previous.homeProductsStatus != current.homeProductsStatus;
          },

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

              return CommonErrorPage(
                isForNetwork: true,
                description: errorMsg,
                onRetry: () {
                  context.read<HomeBloc>().add(HomeCallProductsEvent());
                  // BlocProvider.of<HomeBloc>(
                  //   context,
                  // ).add(HomeCallProductsEvent());
                },
              );
            }

            // Completed State Status
            if (state.homeProductsStatus is HomeProductsStatusCompleted) {
              final HomeProductsStatusCompleted cmProducts =
                  state.homeProductsStatus as HomeProductsStatusCompleted;

              final ProductsModel productsModel = cmProducts.products;

              return LiquidPullToRefresh(
                backgroundColor: theme.scaffoldBackgroundColor,
                color: theme.primaryColor,
                showChildOpacityTransition: true,
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(
                    context,
                  ).add(HomeCallProductsEvent());

                  // with extension
                  // context.read<HomeBloc>().add(HomeCallProductsEvent());
                },
                child: ListView.builder(
                  itemCount: productsModel.products.length,
                  itemBuilder: (context, index) {
                    final Product current = productsModel.products[index];
                    return HomeSingleListItem(current: current);
                  },
                ),
              );
            }

            return Container();
          },
          // Listener
          listener: (BuildContext context, HomeState state) async {
            // Home Completed state
            if (state.homeProductsStatus is HomeProductsStatusCompleted) {
              final HomeProductsStatusCompleted cmProducts =
                  state.homeProductsStatus as HomeProductsStatusCompleted;
              final ProductsModel productsModel = cmProducts.products;
              final bool isConnected = await di<InternetConnectionHelper>()
                  .checkInternetConnection();

              final String msg = isConnected
                  ? "From Server 🌐"
                  : "From Local Source 💾";

              CustomAlert.show(context, productsModel.message + msg);
            }
          },
        ),
      ),
    );
  }
}
