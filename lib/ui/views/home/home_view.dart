import 'package:flutter/material.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/ui/common/app_colors.dart';
import 'package:flutter_base/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                verticalSpaceLarge,
                Column(
                  children: [
                    Text(
                      S.current.hello_stacked,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    verticalSpaceMedium,
                    MaterialButton(
                      color: Colors.black,
                      onPressed: viewModel.incrementCounter,
                      child: Text(
                        viewModel.counterLabel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        color: kcDarkGreyColor,
                        onPressed: viewModel.showDialog,
                        child: const Text(
                          'Show Dialog',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        color: kcDarkGreyColor,
                        onPressed: viewModel.showBottomSheet,
                        child: const Text(
                          'Show Bottom Sheet',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
