import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class Loader<B extends StateStreamable<S>, S> extends StatelessWidget {
  final BlocWidgetSelector<S, bool> selector;

  const Loader({super.key, required this.selector});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, bool>(
        selector: selector,
        builder: (context, loading) {
          return Visibility(
            visible: loading,
            child: Expanded(
              child: Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    fit: BoxFit.cover,
                    repeat: true,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
