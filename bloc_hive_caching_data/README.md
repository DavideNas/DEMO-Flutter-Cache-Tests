# bloc_hive_caching_data

A Flutter project to store cache with hive and bloc pattern.

From YT video:

- https://www.youtube.com/watch?v=GHWPfxpkBoM

## Getting Started

Your **_pubspec.yaml_** file must have following dependencies and dev_dependencies:

```yml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8

  # Theme
  flex_color_scheme: ^8.4.0
  # Google Fonts
  google_fonts: ^6.0.0

  # Icons
  remixicon: ^1.4.1
  iconly: ^1.0.1

  # Log
  logger: ^2.6.2

  # Date, Time
  intl: ^0.20.2

  # Show images from the internet and keep them in the cache directory
  cached_network_image: ^3.2.3

  hive: ^2.2.3
  hive_flutter: ^1.1.0
  hive_generator: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0

  build_runner: ^2.4.13
```

> The version of build_runner must be compatible with hive_generator package.

Follow initial steps from YT video to minute 5:00.

Once model is converted to hive by the menu option **"[Hive] Convert To Hive"**, delete classes :

- register_adapters.dart
- hive_adapters.dart

Then copy /hive_helper/ folder to /model/ where product_field.dart is.

run bash command to generate

```sh
flutter packages pub run build_runner build --delete-conflicting-outputs
```

> If give any error check compatibility packages with AI prompt ad rerun the command.

Next steps from minute 6:49
