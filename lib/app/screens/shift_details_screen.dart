import 'package:flutter/material.dart';
import 'package:flutter_intern/app/getx/shift_details_controller.dart';
import 'package:get/get.dart';
import '../controller/text_design.dart';
import '../widgets/car_information.dart';

class ShiftDetailsScreen extends StatefulWidget {
  final int? shiftId; // Add shiftId parameter

  const ShiftDetailsScreen({super.key, this.shiftId});

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftDetailsController());

    if (widget.shiftId != null) {
      controller.initializeWithShiftId(widget.shiftId!);
    }

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text("Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final currentShiftId =
                  controller.shiftData.value?.id ?? widget.shiftId;
              if (currentShiftId != null) {
                controller.getShiftDetails(currentShiftId);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading shift details...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (controller.shiftDetailsData.value == null &&
            !controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load shift details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final currentShiftId =
                        controller.shiftData.value?.id ?? widget.shiftId;
                    if (currentShiftId != null) {
                      controller.getShiftDetails(currentShiftId);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shift time summary
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Shift Time Summary",
                        style: TextDesign.bodyMediumTextStyle(25),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          shiftTimeSummary(
                            Icons.calendar_today,
                            controller.plannedTime.value,
                            "Planned",
                          ),
                          shiftTimeSummary(
                            Icons.access_time,
                            "Used",
                            controller.usedTime.value,
                          ),
                          shiftTimeSummary(
                            Icons.coffee,
                            "Break",
                            controller.breakTime.value,
                          ),
                          shiftTimeSummary(
                            Icons.work,
                            "Worked",
                            controller.workedTime.value,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Shift details
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarInformation(controller: controller),

                      SizedBox(height: 8),
                      Text(
                        "Schedule",
                        style: TextDesign.bodySmallTextStyle(16),
                      ),
                      Text(
                        controller.time.value,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Text("Address", style: TextDesign.bodySmallTextStyle(16)),
                      Text(controller.address.value),
                      SizedBox(height: 12),
                      Text(
                        "Co-drivers",
                        style: TextDesign.bodySmallTextStyle(16),
                      ),
                      Text(controller.coDrivers.value),
                      SizedBox(height: 12),
                      Text(
                        "Car & License",
                        style: TextDesign.bodySmallTextStyle(16),
                      ),
                      Text(controller.carNumber.value),
                      SizedBox(height: 12),
                      Text(
                        "Instruction",
                        style: TextDesign.bodySmallTextStyle(16),
                      ),
                      Text(controller.instruction.value),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Overview
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: OverView(controller),
                ),
              ),

              // Capacity Summary
              if (controller.shiftDetailsData.value != null) ...[
                const SizedBox(height: 12),
              ],
            ],
          ),
        );
      }),
    );
  }

  Column OverView(ShiftDetailsController controller) {
    return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    overview(
                      "Request",
                      controller.requestsDone.value,
                      controller.requestsTotal.value,
                    ),
                    const SizedBox(height: 20),
                    overview(
                      "Stops",
                      controller.stopsDone.value,
                      controller.stopsTotal.value,
                    ),
                    const SizedBox(height: 20),
                    overview(
                      "Products",
                      controller.packagesDone.value,
                      controller.packagesTotal.value,
                    ),
                  ],
                );
  }

  Widget shiftTimeSummary(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget overview(String label, int done, int total) {
    final percentage = total > 0 ? done / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text("$done/$total")],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage == 1.0
                  ? Colors.green
                  : percentage > 0.5
                  ? Colors.orange
                  : Colors.red,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }


}




