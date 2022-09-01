import 'package:flutter/material.dart';

class DismissKeyboardOnScroll extends StatelessWidget {
  const DismissKeyboardOnScroll({Key? key, this.child, this.onDismiss})
      : super(key: key);

  final Widget? child;
  final Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollStartNotification>(
      onNotification: (ScrollStartNotification notification) {
        if (notification.dragDetails == null) {
          return false;
        }
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
        if (onDismiss != null) {
          onDismiss?.call();
        }

        return true;
      },
      child: child!,
    );
  }
}

class DismissKeyboardOnTap extends StatelessWidget {
  const DismissKeyboardOnTap({Key? key, this.child, this.onDismiss})
      : super(key: key);

  final Widget? child;
  final Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
        if (onDismiss != null) {
          onDismiss?.call();
        }
      },
      child: child,
    );
  }
}
