import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final appBarVisibilityProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, screenKey) => true,
);

class AppBarScrollHandler {
  final WidgetRef ref;
  final String screenKey;

  AppBarScrollHandler(this.ref, {required this.screenKey});

  bool handleScrollNotification(
    UserScrollNotification notification, {
    VoidCallback? onHide,
    VoidCallback? onShow,
  }) {
    final isVisible = ref.read(appBarVisibilityProvider(screenKey));

    if (notification.direction == ScrollDirection.reverse && isVisible) {
      ref.read(appBarVisibilityProvider(screenKey).notifier).state = false;
      onHide?.call();
    } else if (notification.direction == ScrollDirection.forward &&
        !isVisible) {
      ref.read(appBarVisibilityProvider(screenKey).notifier).state = true;
      onShow?.call();
    }
    return false;
  }
}
