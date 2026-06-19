import 'package:flutter/material.dart';
import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/services/connectivity/connectivity_service.dart';

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
  final bool showConnectivityBanner;
  final ConnectivityService? connectivityService;

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
    this.showConnectivityBanner = true,
    this.connectivityService,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildBackground(
      context,
      child: _buildScaffoldBody(context),
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
        ? Padding(padding: EdgeInsets.all(screenPadding), child: child)
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

  Widget _buildScaffoldBody(BuildContext context) {
    final service =
        connectivityService ??
        (locator.isRegistered<ConnectivityService>()
            ? locator<ConnectivityService>()
            : null);

    if (!showConnectivityBanner || service == null) {
      return _buildBody(context);
    }

    return Column(
      children: [
        _ConnectivityStatusBanner(service: service),
        Expanded(child: _buildBody(context)),
      ],
    );
  }
}

class _ConnectivityStatusBanner extends StatelessWidget {
  final ConnectivityService service;

  const _ConnectivityStatusBanner({required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: service.onConnectionStatusChanged,
      initialData: service.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;

        if (isConnected) {
          return const SizedBox.shrink();
        }

        return Material(
          color: Colors.red.shade700,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'No internet connection',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
