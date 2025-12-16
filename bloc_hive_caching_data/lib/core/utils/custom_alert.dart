import 'package:flutter/material.dart';

class CustomAlert {
  CustomAlert._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
    String msg,
  ) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      // avoid to crash if context isn't mounted
      return ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: SizedBox()));
    }

    messenger.clearSnackBars();

    return messenger.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 61, 146, 64),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
