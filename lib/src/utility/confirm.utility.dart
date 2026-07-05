import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show showDialog, AlertDialog, TextButton;

/// Request confirm no / yes modal
Future<bool> naConfirmModalAsync(BuildContext context, {
  required Widget title,
  required Widget content,
  required String actionNoText,
  required Color? actionNoColor,
  required String actionYesText,
  required Color? actionYesColor
}) {
  // TODO: Implement for Cupertino
  // For now, we only have Material design implemented.
  return _naConfirmModal_material_Async(
    context,
    title         : title,
    content       : content,
    actionNoText  : actionNoText,
    actionNoColor : actionNoColor,
    actionYesText : actionYesText,
    actionYesColor: actionYesColor
  );
}

/// Request confirm no / yes modal
// ignore: non_constant_identifier_names
Future<bool> _naConfirmModal_material_Async(BuildContext context, {
  required Widget title,
  required Widget content,
  required String actionNoText,
  required Color? actionNoColor,
  required String actionYesText,
  required Color? actionYesColor
}) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title  : title,
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child    : Text(
              actionNoText,
              style: TextStyle(color: actionNoColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child    : Text(
              actionYesText,
              style: TextStyle(color: actionYesColor),
            ),
          ),
        ],
      );
    }
  );

  return result ?? false;
}
