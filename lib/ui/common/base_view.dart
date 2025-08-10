import 'package:flutter/material.dart';

/// A reusable base view to ensure consistent screen structure across the app.
/// Supports scrollable content, background image/color, padding, keyboard dismissal, etc.
class DgBaseView extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final ImageProvider<Object>? backgroundImage;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool enablePadding;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final double screenPadding; // In logical pixels
  final bool enableScroll;
  final bool dismissKeyboardOnTap;

  const DgBaseView({
    super.key,
    this.appBar,
    required this.child,
    this.backgroundImage,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.enablePadding = true,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.screenPadding = 0.03,
    this.enableScroll = true,
    this.dismissKeyboardOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildBackground(
      context,
      child: _buildBody(context),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: dismissKeyboardOnTap
          ? GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: content,
            )
          : content,
    );
  }

  /// Wraps content with an optional background image.
  Widget _buildBackground(BuildContext context, {required Widget child}) {
    if (backgroundImage != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage!,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: child,
      );
    }
    return child;
  }

  /// Builds scrollable or fixed body based on [enableScroll].
  Widget _buildBody(BuildContext context) {
    final paddedChild = enablePadding
        ? Padding(
            padding: EdgeInsets.all(screenPadding),
            child: child,
          )
        : child;

    if (!enableScroll) return paddedChild;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: paddedChild),
          ),
        );
      },
    );
  }
}
