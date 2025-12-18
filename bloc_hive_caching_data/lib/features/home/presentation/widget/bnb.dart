import 'package:bloc_hive_caching_data/features/home/presentation/bloc/home_bloc.dart';
import 'package:bloc_hive_caching_data/features/home/presentation/bloc/home_status.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

enum _SelectedTab { home, favorite, add, search, person }

class BNB extends StatefulWidget {
  const BNB({super.key});

  @override
  State<BNB> createState() => _BNBState();
}

class _BNBState extends State<BNB> {
  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<HomeBloc>().state.homeProductsStatus
            is HomeProductsStatusError
        // If any start error not show bottom nav bar
        ? Container()
        : CrystalNavigationBar(
            currentIndex: _SelectedTab.values.indexOf(_selectedTab),
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.black.withValues(alpha: .1),
            borderRadius: 25,
            onTap: _handleIndexChanged,
            items: [
              // Home
              CrystalNavigationBarItem(
                icon: IconlyBold.home,
                unselectedIcon: IconlyLight.home,
                unselectedColor: Colors.white,
                selectedColor: Colors.white,
              ),
              // Favorite
              CrystalNavigationBarItem(
                icon: IconlyBold.heart,
                unselectedIcon: IconlyLight.heart,
                unselectedColor: Colors.white,
                selectedColor: Colors.red,
              ),
              // Add
              CrystalNavigationBarItem(
                icon: IconlyBold.plus,
                unselectedIcon: IconlyLight.plus,
                unselectedColor: Colors.white,
                selectedColor: Colors.white,
              ),
              // Search
              CrystalNavigationBarItem(
                icon: IconlyBold.search,
                unselectedIcon: IconlyLight.search,
                unselectedColor: Colors.white,
                selectedColor: Colors.white,
              ),
              // Profile
              CrystalNavigationBarItem(
                icon: IconlyBold.user_2,
                unselectedIcon: IconlyLight.user,
                unselectedColor: Colors.white,
                selectedColor: Colors.white,
              ),
            ],
          );
  }
}
