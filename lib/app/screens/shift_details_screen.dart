import 'package:flutter/material.dart';
import 'package:flutter_intern/app/getx/shift_details_controller.dart';
import 'package:get/get.dart';
import '../controller/text_design.dart';

class ShiftDetailsScreen extends StatefulWidget {
  const ShiftDetailsScreen({super.key});

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller=Get.put(ShiftDetailsController());
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text("Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Obx(
          ()=> Column(
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
                     Text("Shift Time Summary",style: TextDesign.bodyMediumTextStyle(25),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          shiftTimeSummary(
                            Icons.calendar_today,
                              controller.plannedTime.value
                              , "Planned"
                          ),
                          shiftTimeSummary(Icons.access_time, "Used", controller.usedTime.value),
                          shiftTimeSummary(Icons.coffee, "Break", controller.breakTime.value),
                          shiftTimeSummary(Icons.work, "Worked", controller.workedTime.value),
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
                    children:  [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.shiftId.value,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize:25),
                          ),
                          Text(controller.status.value, style: TextDesign.bodySmallTextStyle(16)),
                        ],
                      ),

                      SizedBox(height: 8),
                      Text("Schedule", style: TextDesign.bodySmallTextStyle(16)),
                      Text(
                        controller.time.value,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Text("Address", style: TextDesign.bodySmallTextStyle(16)),
                      Text(controller.address.value),
                      SizedBox(height: 12),
                      Text("Co-drivers", style: TextDesign.bodySmallTextStyle(16)),
                      Text(controller.coDrivers.value),
                      SizedBox(height: 12),
                      Text("Car & License", style: TextDesign.bodySmallTextStyle(16)),
                      Text(controller.carNumber.value),
                      SizedBox(height: 12),
                      Text("Instruction", style: TextDesign.bodySmallTextStyle(16)),
                      Text(
                        controller.instruction.value
                      ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Overview",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      overview("Request", controller.requestsDone.value, controller.requestsTotal.value),
                      const SizedBox(height: 20),
                      overview("Stops", controller.stopsDone.value, controller.stopsTotal.value),
                      const SizedBox(height: 20),
                      overview("Packages", controller.packagesDone.value, controller.packagesTotal.value),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          child: Stack(
            children: [

              Container(height: 3, color: Colors.green),
              Container(height: 3, width: 20, color: Colors.red),
            ],
          ),
        ),
      ],
    );
  }
}
