import 'package:flutter/material.dart';
import 'package:flutter_intern/app/getx/shift_planner_controller.dart';
import 'package:flutter_intern/app/models/shift_model.dart';
import 'package:flutter_intern/app/screens/shift_details_screen.dart';
import 'package:get/get.dart';

import '../controller/text_design.dart';

class ShiftPlannerScreen extends StatefulWidget {
  @override
  State<ShiftPlannerScreen> createState() => _ShiftPlannerScreenState();
}

class _ShiftPlannerScreenState extends State<ShiftPlannerScreen> {
  ShiftModel shiftModel=ShiftModel();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftPlannerController());

    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title:  Text("Shift Planner",style:TextDesign.bodyMediumTextStyle(25),),
        centerTitle: true,

      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.shifts.isEmpty) {
          return const Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),

                ],
              ),
            ),
          );
        }


        return RefreshIndicator(
          onRefresh: controller.refreshShifts,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.shifts.length,
            itemBuilder: (context, index) {
              if (index == 0) {

                if (index == 0) {

                  return Container(
                    width: double.infinity,

                  );
                }
              }
            final shift = controller.shifts[index];
              return _buildShiftCard(context, shift, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildShiftCard(
    BuildContext context,
  dynamic shift,
    ShiftPlannerController controller,
  ) {

    return shiftcard(shift, controller);
  }

  Card shiftcard(shift, ShiftPlannerController controller) {
    return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: () {
        Get.to(
          () => ShiftDetailsScreen(shiftId: shift.id,carNumber:shiftModel.drivers.toString(),),

        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [

                      const SizedBox(width: 8),

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),


            Row(
              children: [
                Icon(Icons.schedule, size: 30, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Expanded(
                          child: Text(
                            shift.drivers ,
                            style: const TextStyle(
                              fontSize: 20,
                             color: Colors.black
                            ),
                            maxLines: 1,
                            // softWrap: false,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ],),
                      SizedBox(height: 12,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
                          'Start: ${controller.formatDateTime(shift.scheduledStart)}',
                          style: TextDesign.bodySmallTextStyle(15),
                        ),
                        Icon(Icons.arrow_back_ios,size: 15,color: Colors.black87,)
                      ],),

                      Text(
                        'End: ${controller.formatDateTime(shift.scheduledEnd)}',
                        style: TextDesign.bodySmallTextStyle(15)
                      ),
                      Text(
                        'ID: ${shift.id}',
                          style: TextDesign.bodySmallTextStyle(15)
                      ),

                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

          ],
        ),
      ),
    ),
  );
  }

}

