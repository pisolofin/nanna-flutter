import 'package:flutter/widgets.dart';

class NaNotificationUpdatable extends StatelessWidget {
  final Stream<Widget> contentStream;

  const NaNotificationUpdatable(this.contentStream, { super.key });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream : this.contentStream,
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data ?? Container();
      }
    );
  }
}
