import 'package:flutter/material.dart';

import 'three-state-selection.controller.dart';

enum NaThreeStateMode { modeA, modeB, modeC }

/// A widget that provides a 3-state selection logic: All, Except, and Only.
class NaThreeStateSelection extends StatefulWidget {
  final NaThreeStateSelectionController controller;
  final String modeALabel;
  final String modeBLabel;
  final String modeCLabel;

  const NaThreeStateSelection({
    super.key,
    required this.controller,
    required this.modeALabel,
    required this.modeBLabel,
    required this.modeCLabel,
  });

  @override
  State<NaThreeStateSelection> createState() => _NaThreeStateSelectionState();
}

class _NaThreeStateSelectionState extends State<NaThreeStateSelection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // The main toggle buttons for choosing the selection mode.
          ToggleButtons(
            isSelected: [
              widget.controller.value == NaThreeStateMode.modeA,
              widget.controller.value == NaThreeStateMode.modeB,
              widget.controller.value == NaThreeStateMode.modeC,
            ],
            onPressed: (int index) {
              setState(() {
                widget.controller.value = NaThreeStateMode.values[index];
              });
            },
            borderRadius: BorderRadius.circular(8.0),
            constraints: BoxConstraints(
              minHeight: 40.0,
              minWidth: (MediaQuery.of(context).size.width - 64) / 3,
            ),
            children: [
              Text(widget.modeALabel),
              Text(widget.modeBLabel),
              Text(widget.modeCLabel),
            ],
          ),
        ],
      ),
    );
  }
}
