import 'package:flutter/widgets.dart';

class NaErrorView extends StatelessWidget {
  final Object? error;

  const NaErrorView(this.error, { super.key });

  @override
  Widget build(BuildContext context) {
    return Text('Error $error');
  }
}
