import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Shows full screen overlay of waiting
OverlayEntry naOverlayShowFullScreen({ required BuildContext context, required Widget child, Color? color }) {
  final OverlayState overlay = Overlay.of(context);
  final OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned.fill(
      child: Material(
        color: color,
        child: Center(
          child: child
        )
      )
    ),
  );

  // Insert the overlay
  overlay.insert(overlayEntry);

  return overlayEntry;
}

/// Shows full screen overlay of waiting
OverlayEntry naOverlayShowFullScreenWaiting({ required BuildContext context, required String text, Color? color }) {
  return naOverlayShowFullScreen(
    context: context,
    color  : color ?? Color(0x80ffffff),
    child  : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    )
  );
}
