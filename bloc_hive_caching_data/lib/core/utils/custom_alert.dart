import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';

class CustomAlert {
  CustomAlert._();

  static show(BuildContext context, String msg) {
    return showAlertBanner(
      context,
      () {},
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 61, 146, 64),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: Colors.white),
        ),
      ),
      alertBannerLocation: AlertBannerLocation.top,
      safeAreaTopEnabled: true,
    );
  }

  // static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
  //   BuildContext context,
  //   String msg,
  // ) {
  //   final messenger = ScaffoldMessenger.maybeOf(context);
  //   if (messenger == null) {
  //     // avoid to crash if context isn't mounted
  //     return ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: SizedBox()));
  //   }

  //   messenger.clearSnackBars();

  //   return messenger.showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         msg,
  //         textAlign: TextAlign.center,
  //         style: Theme.of(
  //           context,
  //         ).textTheme.labelLarge?.copyWith(color: Colors.white),
  //       ),
  //       backgroundColor: const Color.fromARGB(255, 61, 146, 64),
  //       behavior: SnackBarBehavior.floating,
  //       margin: EdgeInsets.only(
  //         top: MediaQuery.of(context).padding.top + 16,
  //         left: 20,
  //         right: 20,
  //       ),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );
  // }
}
