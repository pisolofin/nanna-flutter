
import 'package:flutter/widgets.dart';

import '../view/error-view.widget.dart';

import 'loading-indicator.widget.dart';

typedef NaLoadingBuilderEmptyCheck<T> = bool Function(T? value);

class NaLoadingBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final AsyncWidgetBuilder<T> builder;
  final T? initialData;

  /// Custom no data message
  final String? noDataMessage;
  /// Custom function to check if data is empty
  final NaLoadingBuilderEmptyCheck<T>? checkEmptyFn;

  /// Custom loading widget
  final Widget? loadingWidget;
  /// Custom error widget
  final Widget? errorWidget;
  /// Custom noData widget
  final Widget? noDataWidget;

  const NaLoadingBuilder({
    super.key,
    required this.future,
    this.initialData,
    required this.builder,

    this.noDataMessage,
    this.checkEmptyFn,

    this.loadingWidget,
    this.errorWidget,
    this.noDataWidget
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key        : this.key,
      future     : this.future,
      initialData: this.initialData,
      builder    : (context, snapshot) {
        // Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return this.loadingWidget ?? const NaLoadingIndicator();
        }
        // Error view
        if (snapshot.hasError) {
          return Center(
            child: this.errorWidget ?? NaErrorView(snapshot.error)
          );
        }
        // Empty data
        if ((this.checkEmptyFn != null) && (this.checkEmptyFn!(snapshot.data)) ||
            (this.checkEmptyFn == null) && (snapshot.data == null)
        ) {
          return Center(
            child: this.noDataWidget ?? NaErrorView(
              this.noDataMessage ?? 'No data'
            ),
          );
        }

        return this.builder(context, snapshot);
      },
    );
  }
}
