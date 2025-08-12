import 'package:flutter/material.dart';
import 'package:flutter_intern/app/getx/shift_details_controller.dart';
import 'package:flutter_intern/app/getx/shift_planner_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
class ShiftPlannerScreen extends StatefulWidget {
  @override
  State<ShiftPlannerScreen> createState() => _ShiftPlannerScreenState();
}

class _ShiftPlannerScreenState extends State<ShiftPlannerScreen> {

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(ShiftPlannerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shift Planner"),
        centerTitle: true,
      ),
      body:  Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,size: 30,),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                children: [
                                  Text("Ongoing |"),
                                  Text("SH386015"),
                                ],
                              ),

                              Icon(Icons.circle,color: Colors.red,size: 10,),


                            ],
                          ),
                          Obx(
                            ()=> Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(controller.formattedDate.value),
                                IconButton(onPressed: (){}, icon:Icon(Icons.arrow_back_ios,size: 15,))
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text("Address |"),
                              Text("1st")
                            ],
                          )


                        ],
                      ),

                    )
                );
              },
            ),
          ],


      ),
    );
  }
}

