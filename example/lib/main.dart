import 'package:flutter/widgets.dart';

import 'package:nanna/nanna.dart';

/// Esempio di utilizzo della libreria Nanna.
Future main() async {
  // Initialize secure storage
  naSecureStorageInit();

  // Esegue un metodo asincrono di test
  await _testStorageAsync();
}

/// Metodo asincrono privato per testare lo storage.
Future _testStorageAsync() async {
  final bool isFirstLaunch = await naSecureStorageReadBoolAsync('first_launch') ?? true;

  if (isFirstLaunch) {
    print('First launch!');
    await naSecureStorageWriteBoolAsync('first_launch', false);
  }else {
    print('Not first launch.');
  }

  // Lista fittizia per testare le estensioni
  final Iterable<String> fruitList = ['apple', 'banana', 'cherry'];
  final int index = NaIterableExtensions(fruitList).indexWhere((item) => item == 'banana');
  
  if (index >= 0) {
    print('Banana is at index: $index');
  }
}

/// Esempio di Widget Stateful che rispetta tutte le linee guida
class NannaExampleWidget extends StatefulWidget {
  final String title;

  const NannaExampleWidget({
    required this.title,
    super.key,
  });

  @override
  State<NannaExampleWidget> createState() => _NannaExampleWidgetState();
}

class _NannaExampleWidgetState extends State<NannaExampleWidget> {
  String _message = 'Init';

  @override
  void initState() {
    super.initState();
    _message = widget.title;
  }

  /// Metodo asincrono che non usa `this.` per variabili private
  Future updateMessageAsync() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _message = 'Updated: ${widget.title}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_message),
    );
  }
}
