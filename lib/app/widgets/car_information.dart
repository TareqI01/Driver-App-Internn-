import 'package:flutter/material.dart';

import '../controller/text_design.dart';
import '../getx/shift_details_controller.dart';

class CarInformation extends StatelessWidget {
  const CarInformation({
    super.key,
    required this.controller,
  });

  final ShiftDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.shiftId.value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
          controller.status.value,
          style: TextDesign.bodySmallTextStyle(16),
        ),
      ],
    );
  }
}